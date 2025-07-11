import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Controllers/global_controller.dart';
import 'package:speak_ez/Services/firestore_helper.dart';
import 'package:speak_ez/Utils/tts_helper.dart';

import '../Models/lesson_model_new.dart';

class QuestionOptionsController extends GetxController {
  var currentQuestionIndex = 0.obs;
  final questionPageController = PageController();
  var currentSelectedOptionIndex = 100.obs;
  var questionDifficultyLevel = 0.obs;
  var sentenceRearrangeTempList = <String>[].obs;
  var sentenceRearrangeOptionList = <String>[].obs;
  final ttsHelper = TextToSpeechService();
  var correctAnswer = 0.obs;
  var currentWordMeaningIndex = 0.obs;
  var currentGrammerTipIndex = 0.obs;

  final wordMeaningPageController = PageController();
  final grammerTipPageController   = PageController();
    

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

  // void shouldEnableContinueButton(QuestionType questionType) {
  //   switch (questionType) {
  //     case QuestionType.sentenceRearranging:
  //       isContinueButtonEnabled.value = sentenceRearrangeTempList.isNotEmpty;
  //       break;

  //     default:
  //       isContinueButtonEnabled.value = currentSelectedOptionIndex.value != 100;
  //       break;
  //   }
  // }

  bool comparing2Lists(List<String> list1, List<dynamic> list2) {
    List<String> list3 = list2.map((e) => e.toString()).toList();
    bool areEqual =
        list1.length == list3.length &&
        list1.asMap().entries.every((entry) => entry.value == list3[entry.key]);
    return areEqual;
  }

  // void moveToNextQuestion() {
  //   if (currentQuestionIndex.value < currentLesson.value.questions.length - 1) {
  //     currentQuestionIndex.value++;
  //     questionPageController.jumpToPage(currentQuestionIndex.value);
  //     currentSelectedOptionIndex.value = 100;
  //   } else {
  //     Get.offAll(() => ResultScreen());
  //   }
  // }

  // void showAnswerResultBottomSheet({
  //   required bool isAnswerCorrect,
  //   required String correctAnswer,
  // }) {
  //   showModalBottomSheet(
  //     context: Get.context!,
  //     isDismissible: false,
  //     enableDrag: false,
  //     backgroundColor: Colors.transparent,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.only(
  //         topLeft: Radius.circular(20),
  //         topRight: Radius.circular(20),
  //       ),
  //     ),
  //     isScrollControlled: true,
  //     builder:
  //         (context) => AnswerResultBottomSheet(
  //           isAnswerCorrect: isAnswerCorrect,
  //           correctAnswer: correctAnswer,
  //         ),
  //   );
  // }
}
