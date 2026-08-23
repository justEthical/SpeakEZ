import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Controllers/onboarding_controller.dart';
import 'package:speak_ez/Models/onboarding_questions_model.dart';
import 'package:speak_ez/Screens/HomeScreen/Widgets/home_palette.dart';

class QuestionProgressBar extends StatelessWidget {
  const QuestionProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<OnboardingController>();
    final palette = HomePalette(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final trackWidth = constraints.maxWidth;
        return ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Stack(
            children: [
              Container(
                height: 10,
                width: trackWidth,
                color: palette.progressTrack,
              ),
              Obx(
                () => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  width: (trackWidth / onboardingQuestions.length) *
                      (c.currentOnboardingQuestionIndex.value + 1),
                  height: 10,
                  decoration: BoxDecoration(
                    color: palette.primary,
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
