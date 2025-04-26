import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Controllers/global_controller.dart';
import 'package:speak_ez/Models/onboarding_questions_model.dart';

class QuestionProgressBar extends StatelessWidget {
  const QuestionProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 10,
          width: Get.width,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 232, 196, 255),
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          child: Obx(
            () => AnimatedContainer(
              duration: Duration(milliseconds: 300),
              width:
                  ((Get.width / onboardingQuestions.length) *
                      (globalController.currentOnboardingQuestionIndex.value +
                          1)) -
                  40,
              height: 10,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 75, 10, 120),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
