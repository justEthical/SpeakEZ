import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Controllers/global_controller.dart';
import 'package:speak_ez/Models/onboardin_questions_model.dart';
import 'package:speak_ez/Screens/OnBoarding/Widgets/question_and_options.dart';
import 'package:speak_ez/Screens/OnBoarding/Widgets/question_progress_bar.dart';

class OnboarindQuestions extends StatelessWidget {
  const OnboarindQuestions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.purple),
          onPressed: () {
            if (globalController.onboardingQuestionsController.page != 0) {
              globalController.onboardingQuestionsController.previousPage(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeIn,
              );
              globalController.currentOnboardingQuestionIndex.value--;
            }
          },
        ),
        title: const Text(
          'Back',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        titleSpacing: -10,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tell us about yourself',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Help us personalize your experience',
              style: TextStyle(fontSize: 20, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            QuestionProgressBar(),
            const SizedBox(height: 30),
            QuestionAndOptions(),
          ],
        ),
      ),
    );
  }
}
