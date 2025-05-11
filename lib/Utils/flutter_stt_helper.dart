import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechService {
  final stt.SpeechToText _speech = stt.SpeechToText();

  bool isListening = false;
  String recognizedText = '';

  Future<void> startListening(Function(String) onResult) async {
    bool available = await _speech.initialize(
      onStatus: (status) => print('Status: $status'),
      onError: (error) => print('Error: $error'),
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
      print('Speech recognition not available');
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
