import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sherpa_onnx/sherpa_onnx.dart';
import 'package:speak_ez/Controllers/global_controller.dart';

class WhisperHelper {
  static Future<void> transcribe(List<dynamic> args) async {
    final filePath = args[0];
    final docDirctoryPath = args[1];
    final RootIsolateToken token = args[2];
    final SendPort replyTo = args[3];

    BackgroundIsolateBinaryMessenger.ensureInitialized(token);

    initBindings();

    final t0 = DateTime.now().millisecondsSinceEpoch;
    final recognizerLoadStart = t0;

    final recognizer = initWhisperRecognizer(docDirctoryPath);

    final recognizerLoadEnd = DateTime.now().millisecondsSinceEpoch;
    print("📦 Model loaded in ${recognizerLoadEnd - recognizerLoadStart} ms");

    final offlineStream = recognizer.createStream();

    final audioLoadStart = DateTime.now().millisecondsSinceEpoch;
    final bytes = await File(filePath).readAsBytes();
    final audioLoadEnd = DateTime.now().millisecondsSinceEpoch;
    print("🎧 Audio loaded in ${audioLoadEnd - audioLoadStart} ms");

    final sampleFloat32 = downmixAndNormalizeWav(bytes);

    final decodeStart = DateTime.now().millisecondsSinceEpoch;
    offlineStream.acceptWaveform(sampleRate: 16000, samples: sampleFloat32);
    recognizer.decode(offlineStream);
    final result = recognizer.getResult(offlineStream);
    final decodeEnd = DateTime.now().millisecondsSinceEpoch;

    print("🧠 Decode time: ${decodeEnd - decodeStart} ms");
    print("📝 Transcript: ${result.text}");

    offlineStream.free();
    recognizer.free();

    replyTo.send(result.text);
  }

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
      if (message is Map &&
          message.containsKey('file') &&
          message.containsKey('replyTo')) {
        final filePath = message['file'] as String;
        final SendPort replyTo = message['replyTo'] as SendPort;

        final bytes = await File(filePath).readAsBytes();
        final samples = downmixAndNormalizeWav(bytes);

        final stream = recognizer.createStream();
        stream.acceptWaveform(sampleRate: 16000, samples: samples);
        recognizer.decode(stream);
        final result = recognizer.getResult(stream);
        stream.free();

        replyTo.send(result.text); // send back transcription
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
            encoder: '${dir.path}/base.en-encoder.int8.onnx',
            decoder: '${dir.path}/base.en-decoder.int8.onnx',
          ),
          tokens: '${dir.path}/base.en-tokens.txt',
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

        replyTo.send('✅ Done');
      } catch (e) {
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
  }

  static Future<bool> isModelAvailable() async {
    final dir = await getApplicationDocumentsDirectory();
    final encoder = File('${dir.path}/base.en-decoder.int8.onnx');
    return encoder.existsSync(); // Fast check
  }
}
