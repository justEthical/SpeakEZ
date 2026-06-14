import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sherpa_onnx/sherpa_onnx.dart';
import 'package:speak_ez/Constants/app_assets.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Constants/posthog_events.dart';
import 'package:speak_ez/Controllers/global_controller.dart';
import 'package:speak_ez/Models/user_profile.dart';
import 'package:speak_ez/Services/posthog_service.dart';

class CanaryHelper {
  static const modelFlavourName = 'parakeet';

  static void whisperIsolateEntry(List args) async {
    final SendPort mainSendPort = args[0];
    final String modelPath = args[1];
    final RootIsolateToken token = args[2];

    BackgroundIsolateBinaryMessenger.ensureInitialized(token);
    initBindings(); // Must be called in each isolate separately for intialising sherpa onnx

    final initStart = DateTime.now();
    debugPrint('[CanaryHelper] Model init started at $initStart');
    final recognizer = initCanaryRecognizer(modelPath);
    final initEnd = DateTime.now();
    final initMs = initEnd.difference(initStart).inMilliseconds;
    debugPrint('[CanaryHelper] Model init completed in ${initMs}ms');

    final isolateReceivePort = ReceivePort();
    mainSendPort.send(isolateReceivePort.sendPort); // send entry port to main

    await for (final message in isolateReceivePort) {
      if (message is String && message == 'stop') {
        // Graceful shutdown
        recognizer.free();
        isolateReceivePort.close();
        break; // exit the loop and function => isolate terminates
      } else if (message is Map &&
          message.containsKey('samples') &&
          message.containsKey('replyTo')) {
        final SendPort replyTo = message['replyTo'] as SendPort;
        try {
          final samples = message['samples'] as Float32List;

          // Feed raw samples directly — NeMo CTC normalizes features internally.
          final stream = recognizer.createStream();
          stream.acceptWaveform(sampleRate: 16000, samples: samples);
          recognizer.decode(stream);
          final result = recognizer.getResult(stream);
          stream.free();

          replyTo.send(result.text);
        } catch (e) {
          debugPrint('[CanaryHelper] Transcription error: $e');
          replyTo.send('');
        }
      }
    }

    // recognizer.free();
    // isolateReceivePort.close();
  }

  static OfflineRecognizer initCanaryRecognizer(String path) {
    final modelDir = '$path/$modelFlavourName';

    final recognizer = OfflineRecognizer(
      OfflineRecognizerConfig(
        model: OfflineModelConfig(
          nemoCtc: OfflineNemoEncDecCtcModelConfig(
            model: '$modelDir/model.int8.onnx',
          ),
          tokens: '$modelDir/tokens.txt',
          numThreads: 2,
          debug: false,
        ),
      ),
    );
    return recognizer;
  }

  static void listFiles(String path) {
    final directory = Directory(path);

    if (!directory.existsSync()) {
      debugPrint("Directory does not exist");
      return;
    }

    // List all entries
    directory.list().listen((entity) {
      if (entity is File) {
        debugPrint("File: ${entity.path}");
      } else if (entity is Directory) {
        debugPrint("Directory: ${entity.path}");
      }
    });
  }

  static Float32List downmixAndNormalizeWav(Uint8List bytes) {
    final data = ByteData.view(bytes.buffer);

    final numChannels = data.getUint16(22, Endian.little);
    final bitsPerSample = data.getUint16(34, Endian.little);
    final dataOffset = 44;

    if (bitsPerSample != 16) {
      throw Exception('Only 16-bit PCM is supported');
    }

    final outputLength = (bytes.length - dataOffset) ~/ (2 * numChannels);
    final floatSamples = Float32List(outputLength);

    int outIndex = 0;

    for (int i = dataOffset; i < bytes.length; i += 2 * numChannels) {
      int sum = 0;
      for (int c = 0; c < numChannels; c++) {
        int sample = data.getInt16(i + c * 2, Endian.little);
        sum += sample;
      }
      int monoSample = (sum / numChannels).round(); // average
      floatSamples[outIndex++] = monoSample / 32768.0;
    }

    return floatSamples;
  }

  static void runSilentDownload() async {
    // Check if task is already running or pending
    final existingTasks = await FileDownloader().allTasks();

    final alreadyRunning = existingTasks.any(
      (task) => task.taskId == AppStrings.downloadWhisperModelTaskId,
    );

    if (alreadyRunning) {
      debugPrint("Download already running. Not starting again.");
      return;
    }

    final modelDownloadUrl =
        'https://github.com/justEthical/whisper_tiny_onnx/releases/download/v2.0.0/parakeet.zip';
    final dir = await getApplicationDocumentsDirectory(); // Now safe to call
    final zipPath = '${dir.path}/$modelFlavourName.zip';

    if (File(zipPath).existsSync()) {
      await File(zipPath).delete();
    }

    final task = DownloadTask(
      taskId: AppStrings.downloadWhisperModelTaskId,
      url: modelDownloadUrl,
      filename: '$modelFlavourName.zip',
      updates: Updates.statusAndProgress, // request status and progress updates
      requiresWiFi: false,
      retries: 5,
      allowPause: true,
    );

    // Start download, and wait for result. Show progress and status changes
    // while downloading
    final result = await FileDownloader().download(
      task,
      onProgress: (progress) => debugPrint('Progress: ${progress * 100}%'),
      onStatus: (status) => debugPrint('Status: $status'),
    );
    // Act on the result
    if (result.status == TaskStatus.complete) {
      canModelRunOnDevice();
    }
  }

  static Future<void> extractArchieve(String zipPath, String outputDir) async {
    try {
      final inputStream = InputFileStream(zipPath);
      final archive = ZipDecoder().decodeStream(inputStream);

      for (final file in archive.files) {
        debugPrint('[extractArchieve] ${file.name}');
        final outPath = '$outputDir/${file.name}';

        if (file.isDirectory) {
          // Create directory
          await Directory(outPath).create(recursive: true);
        } else {
          // Create file
          final outFile = File(outPath);
          await outFile.create(recursive: true);
          await outFile.writeAsBytes(file.content as List<int>);
        }
      }
    } catch (e) {
      PostHogService.instance.captureError(
        PostHogEvents.whisperError,
        errorMessage: 'Error extracting archive $e',
        location: 'CanaryHelper.extractArchieve',
      );
      debugPrint('Error extracting archive (async): $e');
    }
  }

  static Future<bool> isModelAvailable() async {
    final dir = await getApplicationDocumentsDirectory();
    final encoder = File('${dir.path}/$modelFlavourName/model.int8.onnx');
    return encoder.existsSync(); // Fast check
  }

  static Future<bool> isModelZipAvailable() async {
    final dir = await getApplicationDocumentsDirectory();
    final zipPath = '${dir.path}/$modelFlavourName.zip';
    return await File(zipPath).exists();
  }

  /// Checks if the device can run the Whisper AI model
  /// by spawning a silent isolate and checking the result.
  ///
  /// The check is done by running a small audio file through the
  /// model and checking the result. If the result is received within
  /// 5 seconds, it means the device can run the model.
  ///
  /// The result is stored in the SharedPreferences with the key
  /// [AppStrings.isOnDeviceTranscriptionSupported].
  ///
  /// Additionally, [globalController.isDeepInfraTranscription] is set
  /// to true if the device cannot run the model, and false otherwise.
  static Future<void> canModelRunOnDevice() async {
    final dir = await getApplicationDocumentsDirectory();
    final zipPath = '${dir.path}/$modelFlavourName.zip';
    try {
      await extractArchieve(zipPath, dir.path);
      listFiles(dir.path);
    } catch (e) {
      PostHogService.instance.captureError(
        PostHogEvents.whisperError,
        errorMessage: 'Error during extracting zip file $e',
        location: 'CanaryHelper.canModelRunOnDevice',
      );
      debugPrint('Error Extracting file: $e');
    }

    final ReceivePort onMainReceive = ReceivePort();

    final RootIsolateToken token = RootIsolateToken.instance!;
    final spawnStart = DateTime.now();
    debugPrint('[CanaryHelper] Spawning isolate at $spawnStart');
    await Isolate.spawn(CanaryHelper.whisperIsolateEntry, [
      onMainReceive.sendPort,
      globalController.appDocDirectoryPath,
      token,
    ]);

    final SendPort whisperSendPort = await onMainReceive.first;
    final spawnEnd = DateTime.now();
    final spawnMs = spawnEnd.difference(spawnStart).inMilliseconds;
    debugPrint('[CanaryHelper] Isolate ready (spawn + model init) in ${spawnMs}ms');
    final audioFilePath = await loadAssetToFile(AppAssets.whisperTestAudio);
    final audioBytes = await File(audioFilePath).readAsBytes();
    final samples = downmixAndNormalizeWav(audioBytes);
    final ReceivePort responsePort = ReceivePort();
    final start = DateTime.now();
    whisperSendPort.send({
      'samples': samples,
      'replyTo': responsePort.sendPort,
    });

    final result = await responsePort.first;
    final end = DateTime.now();
    final difference = end.difference(start).inSeconds;
    final isSupported = difference <= 5.0;
    if (isSupported) {
      globalController.prefs?.setBool(
        AppStrings.isOnDeviceTranscriptionSupported,
        true,
      );
      globalController.isDeepInfraTranscription.value = false;
      globalController
          .userProfile
          .value
          .isSupportsOndeviceTranscription = OnDeviceTranscriptionDetails(
        isSupportsOndeviceTranscription: true,
        timeTookFor10SecTranscription: difference,
      );
    } else {
      globalController.prefs?.setBool(
        AppStrings.isOnDeviceTranscriptionSupported,
        false,
      );
      globalController.isDeepInfraTranscription.value = true;
      globalController
          .userProfile
          .value
          .isSupportsOndeviceTranscription = OnDeviceTranscriptionDetails(
        isSupportsOndeviceTranscription: false,
        timeTookFor10SecTranscription: difference,
      );
    }
    PostHogService.instance.capture(
      'on_device_transcription_check',
      properties: {
        'is_supported': isSupported,
        'transcription_time_seconds': difference,
        'model_init_time_ms': spawnMs,
        'result_text': result.toString(),
      },
    );
    globalController.updateProfile();
    debugPrint('TRANSCRIBED: $result');
    try{
      await File(zipPath).delete();
    }catch(e){
      debugPrint('Error deleting zip file: $e');
    }

    whisperSendPort.send('stop');
  }

  static Future<String> loadAssetToFile(String assetPath) async {
    final data = await rootBundle.load(assetPath);
    final bytes = data.buffer.asUint8List();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/${assetPath.split('/').last}');
    await file.writeAsBytes(bytes, flush: true);

    return file.path;
  }
}
