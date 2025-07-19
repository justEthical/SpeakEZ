import 'dart:async';
import 'dart:convert';
import 'dart:isolate';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Controllers/global_controller.dart';
import 'package:speak_ez/Screens/Lessons/Widgets/answer_result_bottom_sheet.dart';
import 'package:speak_ez/Screens/Lessons/result_screen.dart';
import 'package:speak_ez/Services/firestore_helper.dart';
import 'package:speak_ez/Utils/audio_chunk_recorder.dart';
import 'package:speak_ez/Utils/tts_helper.dart';
import 'package:speak_ez/Utils/whisper_helper.dart';

import '../Models/lesson_model.dart';

class QuestionOptionsController extends GetxController {
  var currentQuestionIndex = 0.obs;
  final questionPageController = PageController();
  var currentSelectedOptionIndex = 100.obs;
  // var questionDifficultyLevel = 0.obs;
  var currentQuestionList = <Question>[].obs;
  var sentenceRearrangeTempList = <String>[].obs;
  var sentenceRearrangeOptionList = <String>[].obs;
  final ttsHelper = TextToSpeechService();
  var correctAnswer = 0.obs;
  Timer? _timer;
  var transcriptionText = "".obs;
  var currentWordMeaningIndex = 0.obs;
  var currentGrammerTipIndex = 0.obs;

  var speakingQuestionAccuracy = 0.0;

  final wordMeaningPageController = PageController();
  final grammerTipPageController = PageController();

  var isListeningLessonAnswer = false.obs; // for lessons answers speech to text
  final AudioChunkRecorder recorder = AudioChunkRecorder();
  var isLastChunkTranscribed = false.obs;
  late StreamSubscription<bool> sub;

  var lessonList = [
    "assets/questions/A1/Greetings & Introductions.json",
    "assets/questions/A1/Talking About Yourself.json",
    "assets/questions/A1/Family Members.json",
    "assets/questions/A1/Numbers and Counting.json",
    "assets/questions/A1/Days of the Week.json",
  ];

  var isContinueButtonEnabled = false.obs;
  var isMicOn = false.obs;
  var currenSpeakingText = "".obs;
  late SendPort whisperSendPort;
  var isWhisperInitialized = false.obs;
  var remainingSeconds = 10.obs;
  var sttResult = "".obs;
  var isAudioProcessing = false.obs;

  Future<Lesson> setCurrentLesson() async {
    final profile = globalController.userProfile.value;
    final data = await rootBundle.loadString(
      "assets/lessons/${profile.currentEnglishLevel}/${profile.currentEnglishLevelProgress + 1}.json",
    );
    final jsonString = jsonDecode(data.toString());
    return Lesson.fromJson(jsonString);
  }

  updateLesssonProgress() {
    globalController.userProfile.value.currentEnglishLevelProgress++;
    if (globalController.userProfile.value.lastActive
            .difference(DateTime.now())
            .inDays !=
        0) {
      globalController.userProfile.value.currentStreak++;
    }
    globalController.userProfile.value.lastActive = DateTime.now();

    // updating user profile in local storage
    globalController.prefs?.setString(
      AppStrings.userProfile,
      jsonEncode(globalController.userProfile.value.toMap()),
    );

    // updating user profile in firestore
    FirestoreHelper.updateUserField(globalController.userProfile.value.toMap());
  }

  Future<void> startWhisperIsolate() async {
    final ReceivePort onMainReceive = ReceivePort();

    final RootIsolateToken token = RootIsolateToken.instance!;
    await Isolate.spawn(WhisperHelper.whisperIsolateEntry, [
      onMainReceive.sendPort,
      globalController.appDocDirectoryPath,
      token,
    ]);

    whisperSendPort = await onMainReceive.first;
    isWhisperInitialized.value = true;
    print('Whisper isolate started $whisperSendPort');
  }

  void startRecording() {
    isListeningLessonAnswer.value = true;
    recorder.startAutoRecording(isFromLesson: true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value == 0) {
        stopRecording();
        print("Timer stopped");
      } else {
        // print("Timmer running ${remainingSeconds.value}");
        remainingSeconds.value--;
      }
    });
  }

  void stopRecording() {
    
    _timer?.cancel();
    recorder.stop(isFromLesson: true);
    isAudioProcessing.value = true;
    sub = isLastChunkTranscribed.listen((val) {
      if (val) {
        print(transcriptionText.value);
        isAudioProcessing.value = false;
        isListeningLessonAnswer.value = false;
        remainingSeconds.value = 10;
        sub.cancel();
      }
    });
  }

  String getResultScreenText(double accuracy) {
    if (accuracy > 80) {
      return '''🎉 Amazing job! You nailed it with over 80% accuracy — you’re on fire! 🔥
Your English skills are leveling up fast — keep shining, language champ! 🌟
🚀 Ready to crush the next challenge?''';
    } else if (accuracy > 60) {
      return '''👏 Well done! You scored between 60–80%, and you’re so close to mastery! 🌈
Keep practicing — every try makes you sharper. 💪
✨ Let’s aim even higher next time — you’ve totally got this!''';
    }
    return '''🌟 Good effort! You scored below 60%, but hey, learning is a journey! 🚶‍♂️💬
Mistakes are your secret weapon to get better. 💥
💡 Keep practicing, and you’ll be surprised how fast you improve!''';
  }

  // void showExitBottomSheet(context) {
  //   showModalBottomSheet(
  //     context: context,
  //     showDragHandle: true,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.only(
  //         topLeft: Radius.circular(20),
  //         topRight: Radius.circular(20),
  //       ),
  //     ),
  //     isScrollControlled: true,
  //     builder: (context) => ExitAlertBottomSheet(),
  //   );
  // }

  void shouldEnableContinueButton(QuestionType questionType) {
    switch (questionType) {
      case QuestionType.sentenceRearranging:
        isContinueButtonEnabled.value = sentenceRearrangeTempList.isNotEmpty;
        break;
      case QuestionType.speaking:
        isContinueButtonEnabled.value = true;
      default:
        isContinueButtonEnabled.value = currentSelectedOptionIndex.value != 100;
        break;
    }
  }

  bool comparing2Lists(List<String> list1, List<dynamic> list2) {
    List<String> list3 = list2.map((e) => e.toString()).toList();
    bool areEqual =
        list1.length == list3.length &&
        list1.asMap().entries.every((entry) => entry.value == list3[entry.key]);
    return areEqual;
  }

  void buildQnaList(Lesson lesson) {
    final tmpArray = [];
    while (tmpArray.length < 3) {
      final random = Random();
      int randomNumber = random.nextInt(5);
      if (!tmpArray.contains(randomNumber)) {
        tmpArray.add(randomNumber);
      }
    }
    print(tmpArray);
    for (var i in tmpArray) {
      currentQuestionList.add(lesson.questionPools.vocabulary[i]);
      currentQuestionList.add(lesson.questionPools.sentence[i]);
      currentQuestionList.add(lesson.questionPools.listening[i]);
      currentQuestionList.add(lesson.questionPools.speaking[i]);
    }
  }

  void moveToNextQuestion() {
    if (currentQuestionIndex.value < currentQuestionList.length - 1) {
      currentQuestionIndex.value++;
      questionPageController.jumpToPage(currentQuestionIndex.value);
      currentSelectedOptionIndex.value = 100;
    } else {
      Get.offAll(() => ResultScreen());
    }
  }

  void showAnswerResultBottomSheet({
    required bool isAnswerCorrect,
    required String correctAnswer,
  }) {
    showModalBottomSheet(
      context: Get.context!,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      isScrollControlled: true,
      builder:
          (context) => AnswerResultBottomSheet(
            isAnswerCorrect: isAnswerCorrect,
            correctAnswer: correctAnswer,
          ),
    );
  }

  double calculateAccuracy(String correctAnswer, String userAnswer) {
    final correctAnswerList = correctAnswer.split(' ');
    final userAnswerList = userAnswer.split(' ');
    var match = 0;
    for (
      int i = 0;
      i < correctAnswerList.length && i < userAnswerList.length;
      i++
    ) {
      if (correctAnswerList[i].toLowerCase() ==
          userAnswerList[i].toLowerCase()) {
        match++;
      }
    }
    return (match / correctAnswer.length) * 100;
  }

  bool isSpeakAnswerCorrect() {
    switch (globalController.userProfile.value.currentEnglishLevel) {
      case "A1":
        return speakingQuestionAccuracy >= 50;
      case "A2":
        return speakingQuestionAccuracy >= 60;
      case "B1":
        return speakingQuestionAccuracy >= 70;
      case "B2":
        return speakingQuestionAccuracy >= 80;
      case "C1":
        return speakingQuestionAccuracy >= 90;
      case "C2":
        return speakingQuestionAccuracy == 100;
      default:
        return false;
    }
  }
}
