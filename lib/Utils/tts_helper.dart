import 'dart:async';
import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeechService {
  // Private constructor
  TextToSpeechService._internal();

  // The single instance
  static final TextToSpeechService _instance = TextToSpeechService._internal();

  // Public getter
  static TextToSpeechService get instance => _instance;

  final FlutterTts _tts = FlutterTts();

  Future<void> speak(String text) async {
    await _tts.setLanguage("en-UK"); // "en-UK" is not valid; use "en-GB" or "en-IN"
    await _tts.setPitch(1.0);
    await _tts.setSpeechRate(0.4);
    await _tts.setVolume(1.0);
    await _tts.speak(text);
  }

  Future<void> speakAndWait(String text) async {
    final completer = Completer<void>();

    // Ensure completion is handled once
    _tts.setCompletionHandler(() {
      if (!completer.isCompleted) {
        completer.complete();
      }
    });

    _tts.setCancelHandler(() {
      if (!completer.isCompleted) {
        completer.complete();
      }
    });

    _tts.setErrorHandler((msg) {
      if (!completer.isCompleted) {
        completer.completeError(Exception(msg));
      }
    });

    await _tts.speak(text);
    await completer.future;
  }

  Future<void> stop() async {
    await _tts.stop();
  }
}

final ttsHelper = TextToSpeechService.instance;