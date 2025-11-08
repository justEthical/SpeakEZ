import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sherpa_onnx/sherpa_onnx.dart';
import 'package:speak_ez/Constants/app_assets.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Controllers/global_controller.dart';

class WhisperHelper {
  static const modelName = 'base';

  static void whisperIsolateEntry(List args) async {
    final SendPort mainSendPort = args[0];
    final String modelPath = args[1];
    final RootIsolateToken token = args[2];

    BackgroundIsolateBinaryMessenger.ensureInitialized(token);
    initBindings(); // FFI bindings for sherpa-onnx

    final recognizer = initWhisperRecognizer(modelPath);

    final isolateReceivePort = ReceivePort();
    mainSendPort.send(isolateReceivePort.sendPort); // send entry port to main

    await for (final message in isolateReceivePort) {
      if (message is String && message == 'stop') {
        // Graceful shutdown
        recognizer.free();
        isolateReceivePort.close();
        break; // exit the loop and function => isolate terminates
      } else if (message is Map &&
          message.containsKey('file') &&
          message.containsKey('replyTo')) {
            final SendPort replyTo = message['replyTo'] as SendPort;
        try {
          final filePath = message['file'] as String;
        

        final bytes = await File(filePath).readAsBytes();
        final samples = downmixAndNormalizeWav(bytes);

        final stream = recognizer.createStream();
        stream.acceptWaveform(sampleRate: 16000, samples: samples);
        recognizer.decode(stream);
        final result = recognizer.getResult(stream);
        stream.free();

        replyTo.send(result.text);// send back transcription
        } catch (e) {
          // Note: Cannot use PostHogService in isolate
          replyTo.send(e.toString());
        }
      }
    }

    // recognizer.free();
    // isolateReceivePort.close();
  }

  static OfflineRecognizer initWhisperRecognizer(String path) {
    final dir = Directory(path);

    final recognizer = OfflineRecognizer(
      OfflineRecognizerConfig(
        model: OfflineModelConfig(
          whisper: OfflineWhisperModelConfig(
            encoder: '${dir.path}/$modelName.en-encoder.int8.onnx',
            decoder: '${dir.path}/$modelName.en-decoder.int8.onnx',
          ),
          tokens: '${dir.path}/$modelName.en-tokens.txt',
          modelType: 'whisper',
        ),
      ),
    );
    return recognizer;
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

  static void _modelDownloadWorker(List args) async {
    final RootIsolateToken rootIsolateToken = args[0]; // first arg is token
    final SendPort replyTo = args[1];
    final SendPort downloadProgress = args[2];
    // 🛠 Fix here
    BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);

    final port = ReceivePort();
    replyTo.send(port.sendPort);

    await for (var message in port) {
      final String url = message[0];
      final String fileName = message[1];
      final SendPort replyTo = message[2];

      try {
        final dir =
            await getApplicationDocumentsDirectory(); // Now safe to call
        final zipPath = '${dir.path}/$fileName';

        final dio = Dio();
        print('[Download] Starting from $url');

        await dio.download(
          url,
          zipPath,
          onReceiveProgress: (rec, total) {
            var percent = double.parse((rec / total * 100).toStringAsFixed(1));
            if (total != -1) {
              downloadProgress.send(percent);
              // print(
              //   '[Download Progress] $percent%',
              // );
            }
          },
          options: Options(receiveTimeout: Duration.zero),
        );

        final inputStream = InputFileStream(zipPath);
        final archive = ZipDecoder().decodeStream(inputStream);
        for (final file in archive.files) {
          final outPath = '${dir.path}/${file.name}';
          final outFile = File(outPath);
          await outFile.create(recursive: true);
          await outFile.writeAsBytes(file.content);
          print('[Unzip] Extracted: ${file.name}');
        }

        // delete zip filee
        try {
          final file = File(zipPath);
          if (await file.exists()) {
            await file.delete();
          }
        } catch (e) {
          // Note: Cannot use PostHogService in isolate
          print('Error deleting file: $e');
        }

        replyTo.send('✅ Done');
      } catch (e) {
        // Note: Cannot use PostHogService in isolate
        print('[Error] $e');
        replyTo.send('❌ Failed');
      }

      port.close();
    }
  }
  static void runSilentDownload() async {
    final receivePort = ReceivePort();
    final downloadProgress = ReceivePort();
    final token = RootIsolateToken.instance!;

    await Isolate.spawn(_modelDownloadWorker, [
      token,
      receivePort.sendPort,
      downloadProgress.sendPort,
    ]);

    final sendPort = await receivePort.first as SendPort;

    downloadProgress.listen((data) {
      print("DOWNLOAD PROGRESS $data");
      globalController.aiModelDownloadProgress.value = data;
    });

    final resultPort = ReceivePort();
    sendPort.send([
      'https://github.com/justEthical/whisper_tiny_onnx/releases/download/v1.0.1/vanilla.zip',
      'vanilla.zip',
      resultPort.sendPort,
    ]);

    await resultPort.first; // You can log or ignore
    globalController.isAiModelDownloaded.value = true;
    canModelRunOnDevice();
  }

  static Future<bool> isModelAvailable() async {
    final dir = await getApplicationDocumentsDirectory();
    final encoder = File('${dir.path}/$modelName.en-decoder.int8.onnx');
    return encoder.existsSync(); // Fast check
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
  static Future<void> canModelRunOnDevice()async{
    final ReceivePort onMainReceive = ReceivePort();

      final RootIsolateToken token = RootIsolateToken.instance!;
      await Isolate.spawn(WhisperHelper.whisperIsolateEntry, [
        onMainReceive.sendPort,
        globalController.appDocDirectoryPath,
        token,
      ]);

      final SendPort whisperSendPort = await onMainReceive.first;
      final audioFilePath = await loadAssetToFile(AppAssets.whisperTestAudio);  
      final ReceivePort responsePort = ReceivePort();
      final start = DateTime.now();
      whisperSendPort.send({
        'file': audioFilePath,
        'replyTo': responsePort.sendPort,
      });

      final result = await responsePort.first;
      final end = DateTime.now(); 
      final difference = end.difference(start).inSeconds;
      if(difference <= 5.0) {
        globalController.prefs?.setBool(AppStrings.isOnDeviceTranscriptionSupported, true);
        globalController.isDeepInfraTranscription.value = false;
        globalController.userProfile.value.isSupportsOndeviceTranscription = true;
      }else{
        globalController.prefs?.setBool(AppStrings.isOnDeviceTranscriptionSupported, false);
        globalController.isDeepInfraTranscription.value = true;
        globalController.userProfile.value.isSupportsOndeviceTranscription = false;
      }
      globalController.updateProfile();
      print('TRANSCRIBED: $result');

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
