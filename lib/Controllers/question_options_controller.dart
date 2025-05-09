import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Screens/Questions/Widgets/exit_alert_bs.dart';

import '../Models/questions_model.dart';

class QuestionOptionsController extends GetxController {
  var currentQuestionIndex = 0.obs;
  final questionPageController = PageController();
  var currentSelectedOptionIndex = 100.obs;
  var questionDifficultyLevel = 1.obs;
  var sentenceRearrangeTempList = <String>[].obs;
  var sentenceRearrangeOptionList = <String>[].obs;

  var isContinueButtonEnabled = false.obs;

  var currentLesson =
      Lesson(
        id: "",
        cefrLevel: CEFRLevel.A1.name,
        questions: [],
        purpose: "",
        lessonName: "",
      ).obs;

  Future<void> setCurrentLesson() async {
    final data = await rootBundle.loadString(
      "assets/questions/A1/simple_conversation.json",
    );
    final jsonString = jsonDecode(data.toString());
    currentLesson.value = Lesson.fromJson(jsonString);
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
      builder: (context) => ExitAlertBottomSheet(),
    );
  }

  void shouldEnableContinueButton(QuestionType questionType) {
    switch (questionType) {
      case QuestionType.sentenceRearranging:
        isContinueButtonEnabled.value = sentenceRearrangeTempList.isNotEmpty;
        break;

      default:
        isContinueButtonEnabled.value = currentSelectedOptionIndex.value != 100;
        break;
    }
  }
}
