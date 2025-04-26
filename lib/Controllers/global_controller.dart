import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speak_ez/Models/country_languages.dart';
import 'package:speak_ez/Models/onboarding_questions_model.dart';
import 'package:speak_ez/Services/Network_service.dart';
import 'package:speak_ez/Utils/load_model_helper.dart';

class GlobalController extends GetxController {
  static GlobalController instance = Get.find();
  SharedPreferences? prefs;
  Rxn<User> currentUser = Rxn<User>();
  final cutomTabBarController = PageController(initialPage: 0);
  final onboardingPageIndicator = PageController(initialPage: 0);
  final onboardingQuestionsController = PageController(initialPage: 0);

  var currentOnboardingIndex = 0.obs;
  var currentTabIndex = 0.obs;
  var currentOnboardingQuestionIndex = 0.obs;
  var transcription = "".obs;

  var onboardingQuestionAnswerMap = <String, String>{}.obs;

  void transcribeAudio() async {
    final now = DateTime.now().millisecondsSinceEpoch;
    print("Start: $now");

    final second = DateTime.now().millisecondsSinceEpoch;
    print("Recognizer initialized: ${now - second}");
    final recognizer = await initWhisperRecognizer();
    var offlineStream = recognizer.createStream();
    final bytes = await loadAssetAsBytes("assets/audio/mm1.wav");
    final third = DateTime.now().millisecondsSinceEpoch;
    print("Audio loaded: ${third - second}");
    final sampleFloat32 = convertBytesToFloat32(bytes);
    offlineStream.acceptWaveform(sampleRate: 16000, samples: sampleFloat32);
    recognizer.decode(offlineStream);
    final result = recognizer.getResult(offlineStream);
    print("Transcript: ${result.text}");
    print("End: ${third - DateTime.now().millisecondsSinceEpoch}");
    // setState(() {
    //   this.result = result.text;
    // });
    recognizer.free();
    offlineStream.free();
  }

  void transcribeLiveAudio(Uint8List bytes) async {
    final recognizer = await initWhisperRecognizer();
    var offlineStream = recognizer.createStream();
    var float32Samples = convertBytesToFloat32(bytes);
    offlineStream.acceptWaveform(sampleRate: 16000, samples: float32Samples);
    recognizer.decode(offlineStream);
    final result = recognizer.getResult(offlineStream);
    print("Transcript: ${result.text}");
    transcription.value = result.text;
    recognizer.free();
    offlineStream.free();
  }

  Future<LottieComposition?> customDecoder(List<int> bytes) {
    return LottieComposition.decodeZip(
      bytes,
      filePicker: (files) {
        return files.firstWhereOrNull(
          (f) => f.name.startsWith('animations/') && f.name.endsWith('.json'),
        );
      },
    );
  }
}

GlobalController globalController = GlobalController.instance;
