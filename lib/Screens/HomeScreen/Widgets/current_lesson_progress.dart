import 'package:flutter/material.dart';
import 'package:speak_ez/Constants/app_data.dart';
import 'package:speak_ez/Controllers/global_controller.dart';

class CurrentLessonProgress extends StatelessWidget {
  const CurrentLessonProgress({super.key});

  @override
  Widget build(BuildContext context) {
    final userProfile = globalController.userProfile.value;
    final lessonNames = AppData.lessonNames[userProfile.currentEnglishLevel] ?? [];
    final progress = lessonNames.isNotEmpty
        ? (userProfile.currentEnglishLevelProgress / lessonNames.length)
        : 0.0;

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: LinearProgressIndicator(
        value: progress,
        minHeight: 10,
        backgroundColor: Colors.white.withOpacity(0.2),
        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
      ),
    );
  }
}