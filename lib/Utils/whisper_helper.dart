import 'dart:io';
import 'package:sherpa_onnx/sherpa_onnx.dart';
import 'package:speak_ez/Utils/load_model_helper.dart';

class WhisperHelper {
  // Private constructor
  WhisperHelper._internal();

  // The single instance of the class (lazily created)
  static final WhisperHelper _instance = WhisperHelper._internal();

  // Factory constructor that returns the same instance every time
  factory WhisperHelper() {
    return _instance;
  }

  late OfflineRecognizer recognizer;

  Future<void> init() async {
    recognizer = await initWhisperRecognizer();
  }

  Future<String> transcribe(filePath) async {
    var offlineStream = recognizer.createStream();
    final now = DateTime.now().millisecondsSinceEpoch;
    print("Start: $now");
    final bytes = await File(filePath).readAsBytes();
    final second = DateTime.now().millisecondsSinceEpoch;
    print("Audio loaded: ${now - second}");
    final sampleFloat32 = downmixAndNormalizeWav(bytes);
    offlineStream.acceptWaveform(sampleRate: 16000, samples: sampleFloat32);
    recognizer.decode(offlineStream);
    final result = recognizer.getResult(offlineStream);
    print("Transcript: ${result.text}");
    print("End: ${second - DateTime.now().millisecondsSinceEpoch}");
    offlineStream.free();
    print(result.text);
    return result.text;
  }

  freeReconizer() {
    recognizer.free();
  }
}
