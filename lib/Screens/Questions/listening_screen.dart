import 'package:flutter/material.dart';
import 'package:speak_ez/Utils/tts_helper.dart';

class ListeningScreen extends StatelessWidget {
  const ListeningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("Listen the audio carefully and select the correct option"),
              IconButton(onPressed: () {
                final tts = TextToSpeechService();
                tts.speak("Listen the audio carefully and select the correct option");
              }, icon: Icon(Icons.mic)),
              SizedBox(height: 10),
              ElevatedButton(onPressed: () {}, child: Text("I am fine.")),
              ElevatedButton(onPressed: () {}, child: Text("Am i fine?")),
              ElevatedButton(onPressed: () {}, child: Text("Fine i am .")),
            ],
          ),
        ),
      ),
    );
  }
}
