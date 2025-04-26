import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Controllers/onboarding_controller.dart';
import 'package:speak_ez/Models/onboarding_questions_model.dart';
import 'package:speak_ez/Screens/OnBoarding/Widgets/option_builder.dart';

/// A widget that displays a question with multiple options.
/// When an option is tapped, it changes to purple with white text.
class QuestionAndOptions extends StatelessWidget {
  const QuestionAndOptions({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<OnboardingController>();
    return Expanded(
      child: Container(
        height: Get.height * 0.6,

        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Obx(
          () => PageView.builder(
            itemCount: onboardingQuestions.length,
            scrollDirection: Axis.horizontal,
            controller: c.onboardingQuestionsController,
            itemBuilder: (ctx, i) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Question ${i + 1} of ${onboardingQuestions.length}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    onboardingQuestions[i].question,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children:
                            onboardingQuestions[i].options
                                .map(
                                  (option) => OptionsBuilder(
                                    model: onboardingQuestions[i],
                                    label: option,
                                  ),
                                )
                                .toList(),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
