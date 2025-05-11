import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sherpa_onnx/sherpa_onnx.dart';
import 'package:speak_ez/Utils/load_model_helper.dart';

class WhisperAi extends StatefulWidget {
  const WhisperAi({super.key});

  @override
  State<WhisperAi> createState() => _WhisperAiState();
}

class _WhisperAiState extends State<WhisperAi> {
  var result = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () async {
      if (!await isModelAvailable()) {
        runSilentDownload();
      } else {
        initBindings();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: Column(
          children: [
            const Spacer(),
            Text(result),
            ElevatedButton(
              onPressed: () async {
                final now = DateTime.now().millisecondsSinceEpoch;
                print("Start: $now");
                final recognizer = await initWhisperRecognizer();
                final second = DateTime.now().millisecondsSinceEpoch;
                print("Recognizer initialized: ${now - second}");
                var offlineStream = recognizer.createStream();
                final bytes = await loadAssetAsBytes("assets/audio/jfk.wav");
                final third = DateTime.now().millisecondsSinceEpoch;
                print("Audio loaded: ${third - second}");
                final sampleFloat32 = convertBytesToFloat32(bytes);
                offlineStream.acceptWaveform(
                  sampleRate: 16000,
                  samples: sampleFloat32,
                );
                recognizer.decode(offlineStream);
                final result = recognizer.getResult(offlineStream);
                print("Transcript: ${result.text}");
                print("End: ${third - DateTime.now().millisecondsSinceEpoch}");
                setState(() {
                  this.result = result.text;
                });
                recognizer.free();
                offlineStream.free();
              },
              child: const Text("DO NOT PRESS"),
            ),
          ],
        ),
      ),
    );
  }

  Future<Uint8List> loadAssetAsBytes(String path) async {
    ByteData byteData = await rootBundle.load(path);
    return byteData.buffer.asUint8List();
  }
}
