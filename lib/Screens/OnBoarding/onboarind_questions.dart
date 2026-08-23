import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Controllers/onboarding_controller.dart';
import 'package:speak_ez/Screens/HomeScreen/Widgets/home_palette.dart';
import 'package:speak_ez/Screens/OnBoarding/Widgets/question_and_options.dart';
import 'package:speak_ez/Screens/OnBoarding/Widgets/question_progress_bar.dart';

class OnboarindQuestions extends StatefulWidget {
  const OnboarindQuestions({super.key});

  @override
  State<OnboarindQuestions> createState() => _OnboarindQuestionsState();
}

class _OnboarindQuestionsState extends State<OnboarindQuestions> {
  final c = Get.find<OnboardingController>();

  @override
  void initState() {
    super.initState();
    c.addLanguageBasedQuestionInOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    final palette = HomePalette(context);
    return Scaffold(
      backgroundColor: palette.background,
      appBar: AppBar(
        backgroundColor: palette.background,
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: palette.onSurface, size: 20),
          onPressed: () {
            if (c.currentOnboardingQuestionIndex.value != 0) {
              c.goToPreviousQuestion();
            } else {
              Get.back();
            }
          },
        ),
        // Learna-style: thin progress bar sits inline at the very top.
        title: const Padding(
          padding: EdgeInsets.only(right: 20),
          child: QuestionProgressBar(),
        ),
      ),
      body: const SafeArea(
        top: false, // AppBar handles the top
        child: QuestionAndOptions(),
      ),
    );
  }
}
