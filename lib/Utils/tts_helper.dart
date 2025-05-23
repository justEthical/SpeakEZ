import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeechService {
  final FlutterTts _tts = FlutterTts();

  Future<void> speak(String text) async {
    await _tts.setLanguage("en-IN"); // You can change to "en-IN", "en-UK", etc.
    await _tts.setPitch(1.0); // Normal pitch
    await _tts.setSpeechRate(0.4); // Slower for learners
    await _tts.setVolume(1.0); // Max volume
    await _tts.speak(text); // Speak the text
  }

  Future<void> stop() async {
    await _tts.stop();
  }
}
