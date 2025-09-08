import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Constants/app_data.dart';
import 'package:speak_ez/Controllers/global_controller.dart';
import 'package:speak_ez/Screens/Lessons/Widgets/answer_result_bottom_sheet.dart';
import 'package:speak_ez/Screens/Lessons/Widgets/lessons_exit_alert_bs.dart';
import 'package:speak_ez/Screens/Lessons/result_screen.dart';
import 'package:speak_ez/Utils/audio_chunk_recorder.dart';
import 'package:speak_ez/Utils/flutter_stt_helper.dart';
import 'package:speak_ez/Services/posthog_service.dart';

import '../Models/lesson_model.dart';

class QuestionOptionsController extends GetxController {
  var currentQuestionIndex = 0.obs;
  final questionPageController = PageController();
  var currentSelectedOptionIndex = 100.obs;
  // var questionDifficultyLevel = 0.obs;
  var currentQuestionList = <Question>[].obs;
  var sentenceRearrangeTempList = <String>[].obs;
  var sentenceRearrangeOptionList = <String>[].obs;
  // final ttsHelper = TextToSpeechService();
  var correctAnswer = 0.obs;
  Timer? _timer;

  var currentWordMeaningIndex = 0.obs;
  var currentGrammerTipIndex = 0.obs;
  var qnaStartTime = DateTime.now();

  var speakingQuestionAccuracy = 0.0;

  final wordMeaningPageController = PageController();
  final grammerTipPageController = PageController();

  var isListeningLessonAnswer = false.obs; // for lessons answers speech to text
  final AudioChunkRecorder recorder = AudioChunkRecorder();
  late StreamSubscription<bool> sub;

  late Lesson currentLessonModel;

  var isContinueButtonEnabled = false.obs;
  var isMicOn = false.obs;
  var currenSpeakingText = "".obs;
  var remainingSeconds = 10.obs;
  var sttResult = "".obs;
  var isAudioProcessing = false.obs;

  var isFromRetest = false;

  final SpeechService stt = SpeechService();

  Future<Lesson> setCurrentLesson({int? lessonIndex, String? englishLevel}) async {
    final profile = globalController.userProfile.value;

    // Build the relative core path once (e.g., /lessons/A1/14.json)
    final nextLessonIndex = profile.currentEnglishLevelProgress + 1;
    String corePath = '';
    if(lessonIndex != null){
      corePath = "/lessons/$englishLevel/$lessonIndex.json";
    }else{
      corePath = "/lessons/${profile.currentEnglishLevel}/$nextLessonIndex.json";
    }
        

    // Absolute file path in app's documents dir
    // final storagePath = "${globalController.appDocDirectoryPath}$corePath";
    // final storageFile = File(storagePath);

    try {
      // // 1) Try app storage override first
      // if (await storageFile.exists()) {
      //   final text = await storageFile.readAsString();
      //   final map = jsonDecode(text) as Map<String, dynamic>;
      //   return Lesson.fromJson(map);
      // }

      // 2) Fall back to bundled asset
      final assetPath = "assets$corePath";
      final text = await rootBundle.loadString(assetPath);
      final map = jsonDecode(text) as Map<String, dynamic>;
      return Lesson.fromJson(map);
    } on FormatException catch (e) {
      // JSON malformed
      PostHogService.instance.captureError(
        'lesson_load_error',
        errorMessage: "Invalid lesson JSON at $corePath: ${e.message}",
        location: 'QuestionOptionsController.loadLessonFromStorageOrAsset',
        additionalProperties: {'path': corePath},
      );
      throw Exception("Invalid lesson JSON at $corePath: ${e.message}");
    } on FileSystemException catch (e) {
      // IO errors (permissions, missing file when expected, etc.)
      PostHogService.instance.captureError(
        'lesson_load_error',
        errorMessage: "File error while loading lesson: ${e.message}",
        location: 'QuestionOptionsController.loadLessonFromStorageOrAsset',
      );
      throw Exception(
        "File error while loading lesson: ${e.message}",
      );
    } catch (e) {
      // Anything else
      PostHogService.instance.captureError(
        'lesson_load_error',
        errorMessage: "Unexpected error loading lesson $corePath: $e",
        location: 'QuestionOptionsController.loadLessonFromStorageOrAsset',
        additionalProperties: {'path': corePath},
      );
      throw Exception("Unexpected error loading lesson $corePath: $e");
    }
  }

  String formatSecondsToMinutes(int timeInSeconds) {
    final minutes = (timeInSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (timeInSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void updateLesssonProgress() {
    if (globalController.userProfile.value.currentEnglishLevelProgress >= 49) {
      final currentEnglishLevelIndex = AppData.englishLevel.indexOf(
        globalController.userProfile.value.currentEnglishLevel,
      );
      globalController.userProfile.value.currentEnglishLevel =
          AppData.englishLevel[currentEnglishLevelIndex + 1];
      globalController.userProfile.value.currentEnglishLevelProgress = 0;
    } else {
      globalController.userProfile.value.currentEnglishLevelProgress++;
      final lastActive = globalController.userProfile.value.lastActive;
      final now = DateTime.now();
      if (!(lastActive.year == now.year &&
          lastActive.month == now.month &&
          lastActive.day == now.day)) {
        globalController.userProfile.value.currentStreak++;
      }

      globalController.userProfile.value.wordLearned +=
          currentLessonModel.lessonIntro.vocabulary.length;
      globalController.userProfile.value.lastActive = DateTime.now();
    }

    globalController.updateProfile();
  }

  void startRecording() {
    isListeningLessonAnswer.value = true;
    recorder.startAutoRecording(isFromLesson: true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value == 0) {
        stopRecording();
        print("Timer stopped");
      } else {
        remainingSeconds.value--;
      }
    });
  }

  void googleSpeechToText() {
    isListeningLessonAnswer.value = true;
    stt.startListening(
      (result) {
        globalController.transcriptionText.value = result;
        print(globalController.transcriptionText.value);
      },
      (isListening) {
        globalController.isLastChunkTranscribed.value = isListening;
        // removing bracketed words like [MUSIC], [BLANK], [NOISE] etc
        globalController.transcriptionText.value = removeBracketedWords(
          globalController.transcriptionText.value,
        );
        // removing non alphabet characters like !, @, #, %, comma (,) etc
        globalController.transcriptionText.value = removeNonAlphabet(
          globalController.transcriptionText.value,
        );
        if (globalController.transcriptionText.value.isNotEmpty) {
          isContinueButtonEnabled.value = true;
        }
        if (!isListening) {
          isListeningLessonAnswer.value = false;
        }
      },
    );
  }

  void stopRecording() {
    _timer?.cancel();
    recorder.stop(isFromLesson: true);
    isAudioProcessing.value = true;
    sub = globalController.isLastChunkTranscribed.listen((val) {
      if (val) {
        print(globalController.transcriptionText.value);
        // removing bracketed words like [MUSIC], [BLANK], [NOISE] etc
        globalController.transcriptionText.value = removeBracketedWords(
          globalController.transcriptionText.value,
        );
        // removing non alphabet characters like !, @, #, %, comma (,) etc
        print(globalController.transcriptionText.value);
        globalController.transcriptionText.value = removeNonAlphabet(
          globalController.transcriptionText.value,
        );
        print(globalController.transcriptionText.value);

        isContinueButtonEnabled.value = true;
        isAudioProcessing.value = false;
        isListeningLessonAnswer.value = false;
        remainingSeconds.value = 10;
        sub.cancel();
      }
    });
    stt.cancelListening();
  }

  String removeBracketedWords(String text) {
    // Matches any word starting with [ or (, up to the next space, or closed bracket/parenthesis (greedy).
    final pattern = RegExp(
      r'(\s*[\[\(][^\s\]\)]*[\]\)]?\s*)',
      caseSensitive: false,
    );
    String cleaned = text.replaceAll(pattern, ' ');
    // Remove any extra spaces
    return cleaned.replaceAll(RegExp(r'\s+'), ' ').trim();
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

  var isBottomSheetOpen = false;
  void showExitBottomSheet(context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      isScrollControlled: true,
      builder: (context) => LessonsExitAlertBottomSheet(),
    );
  }

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
    currentQuestionList.clear();
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
          (context) => PopScope(
            canPop: false,
            child: AnswerResultBottomSheet(
              isAnswerCorrect: isAnswerCorrect,
              correctAnswer: correctAnswer,
            ),
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
    print((match / correctAnswerList.length) * 100);
    return (match / correctAnswerList.length) * 100;
  }

  String removeNonAlphabet(String input) {
    return input.replaceAll(RegExp(r'[^a-zA-Z\s]'), '');
  }

  bool isSpeakingQuestionAccurate(double accuracy) {
    switch (globalController.userProfile.value.currentEnglishLevel) {
      case "A1":
        return accuracy >= 50;
      case "A2":
        return accuracy >= 60;
      case "B1":
        return accuracy >= 70;
      case "B2":
        return accuracy >= 80;
      case "C1":
        return accuracy >= 90;
      case "C2":
        return accuracy == 100;
      default:
        return false;
    }
  }
}
