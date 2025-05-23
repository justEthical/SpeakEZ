import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Controllers/onboarding_controller.dart';
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
    // TODO: implement initState
    super.initState();
    c.addLanguageBasedQuestionInOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.purple),
          onPressed: () {
            if (c.onboardingQuestionsController.page != 0) {
              c.onboardingQuestionsController.previousPage(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeIn,
              );
              c.currentOnboardingQuestionIndex.value--;
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
