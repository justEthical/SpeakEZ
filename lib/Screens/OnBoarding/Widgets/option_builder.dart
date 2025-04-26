import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Controllers/global_controller.dart';
import 'package:speak_ez/Controllers/onboarding_controller.dart';
import 'package:speak_ez/Models/onboarding_questions_model.dart';

class OptionsBuilder extends StatelessWidget {
  final OnboardingQuestion model;
  final String label;
  const OptionsBuilder({super.key, required this.model, required this.label});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: () {
          Get.find<OnboardingController>().optionSelected(model, label);
        },
        child: Container(
          width: Get.width,
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color:
                globalController.onboardingQuestionAnswerMap[model.id] == label
                    ? Colors.purple
                    : const Color(0xFFF2F2F2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 15,
                color:
                    globalController.onboardingQuestionAnswerMap[model.id] ==
                            label
                        ? Colors.white
                        : Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
