import 'dart:typed_data';

import 'package:sherpa_onnx/sherpa_onnx.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<String> copyAsset(String assetPath) async {
  final byteData = await rootBundle.load(assetPath);
  final file = File('${(await getTemporaryDirectory()).path}/${assetPath.split('/').last}');
  await file.writeAsBytes(byteData.buffer.asUint8List());
  return file.path;
}

Future<Uint8List> loadAssetAsBytes(String path) async {
    ByteData byteData = await rootBundle.load(path);
    return byteData.buffer.asUint8List();
  }

Future<OfflineRecognizer> initWhisperRecognizer() async {
  const modelDir = 'assets/whisper_model';

  final recognizer = OfflineRecognizer(
   OfflineRecognizerConfig(
    model: OfflineModelConfig(
      whisper: OfflineWhisperModelConfig(
        encoder: await copyAsset('$modelDir/tiny.en-encoder.int8.onnx'),
        decoder: await copyAsset('$modelDir/tiny.en-decoder.int8.onnx'),
      ),
      tokens: await copyAsset('$modelDir/tiny.en-tokens.txt'),
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
