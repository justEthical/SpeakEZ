import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Controllers/onboarding_controller.dart';
import 'package:speak_ez/Models/onboarding_questions_model.dart';
import 'package:speak_ez/Screens/HomeScreen/Widgets/home_palette.dart';

class OptionsBuilder extends StatelessWidget {
  final OnboardingQuestion model;
  final String label;
  const OptionsBuilder({super.key, required this.model, required this.label});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<OnboardingController>();
    final palette = HomePalette(context);

    return Obx(() {
      final storedValue = c.onboardingQuestionAnswerMap[model.id];
      bool isSelected = storedValue == label;

      // Handle custom time option: if this is the last option of preferredPracticeTime,
      // check if stored value is a custom time (not one of the preset times)
      if (!isSelected && model.id == 'preferredPracticeTime') {
        switch (storedValue) {
          case '08:00':
            if (label == '🔅 Morning 8:00 AM') {
              isSelected = true;
            }
            break;
          case '12:00':
            if (label == '☀️ Afternoon 12:00 PM') {
              isSelected = true;
            }
            break;
          case '18:00':
            if (label == '🌙 Evening 6:00 PM') {
              isSelected = true;
            }
            break;
          default:
            if (storedValue != null && label == '⏰ Pick a time') {
              isSelected = true;
            }
        }
      }

      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Get.find<OnboardingController>().optionSelected(model, label);
            },
            borderRadius: BorderRadius.circular(16),
            splashColor: palette.primary.withValues(alpha: 0.1),
            highlightColor: palette.primary.withValues(alpha: 0.05),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              decoration: BoxDecoration(
                color: isSelected
                    ? palette.primary.withValues(alpha: 0.12)
                    : palette.cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? palette.primary : palette.cardBorder,
                  width: isSelected ? 2 : 1.5,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: palette.primary.withValues(alpha: 0.18),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: palette.isDark ? 0.2 : 0.04,
                          ),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: AppStrings.nunitoFont,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w600,
                        color:
                            isSelected ? palette.primary : palette.onSurface,
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? palette.primary : Colors.transparent,
                      border: Border.all(
                        color: isSelected
                            ? palette.primary
                            : palette.onSurfaceVariant.withValues(alpha: 0.5),
                        width: 2,
                      ),
                    ),
                    child: isSelected
                        ? Icon(
                            Icons.check,
                            size: 16,
                            color: palette.isDark
                                ? const Color(0xFF091421)
                                : Colors.white,
                          )
                        : null,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
