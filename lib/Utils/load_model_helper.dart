import 'dart:isolate';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:dio/dio.dart';
import 'package:sherpa_onnx/sherpa_onnx.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<String> copyAsset(String assetPath) async {
  final byteData = await rootBundle.load(assetPath);
  final file = File(
    '${(await getTemporaryDirectory()).path}/${assetPath.split('/').last}',
  );
  await file.writeAsBytes(byteData.buffer.asUint8List());
  return file.path;
}

Future<Uint8List> loadAssetAsBytes(String path) async {
  ByteData byteData = await rootBundle.load(path);
  return byteData.buffer.asUint8List();
}

Future<OfflineRecognizer> initWhisperRecognizer() async {
  final dir = await getApplicationDocumentsDirectory();

  final recognizer = OfflineRecognizer(
    OfflineRecognizerConfig(
      model: OfflineModelConfig(
        whisper: OfflineWhisperModelConfig(
          encoder: '${dir.path}/tiny.en-encoder.int8.onnx',
          decoder: '${dir.path}/tiny.en-decoder.int8.onnx',
        ),
        tokens: '${dir.path}/tiny.en-tokens.txt',
        modelType: 'whisper',
      ),
    ),
  );
  return recognizer;
}

Float32List convertBytesToFloat32(Uint8List bytes, [endian = Endian.little]) {
  final values = Float32List(bytes.length ~/ 2);

  final data = ByteData.view(bytes.buffer);

  for (var i = 0; i < bytes.length; i += 2) {
    int short = data.getInt16(i, endian);
    values[i ~/ 2] = short / 32678.0;
  }

  return values;
}

void _modelDownloadWorker(List args) async {
  final RootIsolateToken rootIsolateToken = args[0]; // first arg is token
  final SendPort replyTo = args[1];
  // 🛠 Fix here
  BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);

  final port = ReceivePort();
  replyTo.send(port.sendPort);

  await for (var message in port) {
    final String url = message[0];
    final String fileName = message[1];
    final SendPort replyTo = message[2];

    try {
      final dir = await getApplicationDocumentsDirectory(); // Now safe to call
      final zipPath = '${dir.path}/$fileName';

      final dio = Dio();
      print('[Download] Starting from $url');

      await dio.download(
        url,
        zipPath,
        onReceiveProgress: (rec, total) {
          if (total != -1) {
            print(
              '[Download Progress] ${(rec / total * 100).toStringAsFixed(1)}%',
            );
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
      initBindings();
    } catch (e) {
      print('[Error] $e');
      replyTo.send('❌ Failed');
    }

    port.close();
  }
}

void runSilentDownload() async {
  final receivePort = ReceivePort();
  final token = RootIsolateToken.instance!;

  await Isolate.spawn(_modelDownloadWorker, [token, receivePort.sendPort]);

  final sendPort = await receivePort.first as SendPort;

  final resultPort = ReceivePort();
  sendPort.send([
    'https://github.com/justEthical/whisper_tiny_onnx/releases/download/v1.0.0/tiny_en.zip',
    'tiny_en.zip',
    resultPort.sendPort,
  ]);

  await resultPort.first; // You can log or ignore
}

Future<bool> isModelAvailable() async {
  final dir = await getApplicationDocumentsDirectory();
  final encoder = File('${dir.path}/tiny.en-decoder.int8.onnx');
  return encoder.existsSync(); // Fast check
}
