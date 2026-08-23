import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Controllers/onboarding_controller.dart';
import 'package:speak_ez/Models/onboarding_questions_model.dart';
import 'package:speak_ez/Screens/HomeScreen/Widgets/home_palette.dart';
import 'package:speak_ez/Screens/OnBoarding/Widgets/option_builder.dart';

/// Learna-style "hero question": the question is the focus of the screen —
/// large, centred headline with a soft subtitle, options as plain rows on the
/// background (no card-in-a-card). One question per page.
///
/// Questions cross-fade + rise in (matching the home screen's motion) instead
/// of sliding horizontally.
class QuestionAndOptions extends StatelessWidget {
  const QuestionAndOptions({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<OnboardingController>();
    return Obx(() {
      final index = c.currentOnboardingQuestionIndex.value
          .clamp(0, onboardingQuestions.length - 1);
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        // Keep only the incoming page laid out so pages don't overlap-scroll.
        layoutBuilder: (currentChild, previousChildren) =>
            currentChild ?? const SizedBox.shrink(),
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.08),
                end: Offset.zero,
              ).animate(animation),
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.97, end: 1.0).animate(animation),
                child: child,
              ),
            ),
          );
        },
        child: _QuestionPage(
          // Key drives the switch on every question change.
          key: ValueKey(index),
          question: onboardingQuestions[index],
        ),
      );
    });
  }
}

class _QuestionPage extends StatelessWidget {
  final OnboardingQuestion question;
  const _QuestionPage({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    final palette = HomePalette(context);
    final isStatement = question.isStatement;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Give pain statements more breathing room above so the headline
          // floats mid-screen, the way Learna frames its mirroring prompts.
          SizedBox(height: isStatement ? 48 : 12),
          Text(
            question.question,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isStatement ? 28 : 26,
              height: 1.25,
              fontFamily: AppStrings.nunitoFont,
              fontWeight: FontWeight.w800,
              color: palette.onSurface,
            ),
          ),
          if (question.subtitle != null) ...[
            const SizedBox(height: 10),
            Text(
              question.subtitle!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontFamily: AppStrings.nunitoFont,
                fontWeight: FontWeight.w600,
                color: palette.onSurfaceVariant,
              ),
            ),
          ],
          SizedBox(height: isStatement ? 40 : 32),
          ...question.options.map(
            (option) => OptionsBuilder(model: question, label: option),
          ),
          if (question.id == 'motherTongue')
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'More languages coming soon!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: AppStrings.nunitoFont,
                  fontWeight: FontWeight.w500,
                  color: palette.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
