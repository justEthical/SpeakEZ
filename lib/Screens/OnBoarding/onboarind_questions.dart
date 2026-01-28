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
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).colorScheme.onPrimary),
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
        title: Text(
          'Back',
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontSize: 16),
        ),
        titleSpacing: -10,
      ),
      body: SafeArea(
        top: false, // AppBar handles the top
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(
              'Tell us about yourself',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Help us personalize your experience',
              style: TextStyle(fontSize: 18, color: Theme.of(context).textTheme.bodySmall?.color),
            ),
            const SizedBox(height: 20),
            QuestionProgressBar(),
            const SizedBox(height: 20),
            QuestionAndOptions(),
          ],
        ),
        ),
      ),
    );
  }
}
