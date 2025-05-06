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

  var currentLesson =
      Lesson(
        cefrLevel: CEFRLevel.A1,
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
}
