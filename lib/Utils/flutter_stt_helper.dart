import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechService {
  final stt.SpeechToText _speech = stt.SpeechToText();

  bool isListening = false;
  String recognizedText = '';

  Future<void> startListening(Function(String) onResult, Function(bool) isListeningState) async {
    bool available = await _speech.initialize(
      onStatus: (status) {
        debugPrint("Status: $status");
        if (status == "done" || status == "notListening") {
          isListening = false;
          isListeningState(false);
        } 
      },
      onError: (error) {
        debugPrint("Error: $error");
        isListeningState(false);
      },
    );

    if (available) {
      isListening = true;
      _speech.listen(
        onResult: (result) {
          recognizedText = result.recognizedWords;
          onResult(recognizedText); // callback to update UI or state
        },
      );
    } else {
      debugPrint('Speech recognition not available');
    }
  }

  void stopListening() {
    _speech.stop();
    isListening = false;
  }

  void cancelListening() {
    _speech.cancel();
    isListening = false;
  }
}
