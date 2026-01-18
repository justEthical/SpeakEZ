import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Controllers/onboarding_controller.dart';
import 'package:speak_ez/Models/onboarding_questions_model.dart';

class OptionsBuilder extends StatelessWidget {
  final OnboardingQuestion model;
  final String label;
  const OptionsBuilder({super.key, required this.model, required this.label});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<OnboardingController>();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      final isSelected = c.onboardingQuestionAnswerMap[model.id] == label;

      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Get.find<OnboardingController>().optionSelected(model, label);
            },
            borderRadius: BorderRadius.circular(14),
            splashColor: Colors.green.withValues(alpha: 0.1),
            highlightColor: Colors.green.withValues(alpha: 0.05),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.green
                    : isDarkMode
                        ? Colors.grey.shade800.withValues(alpha: 0.5)
                        : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected
                      ? Colors.green
                      : isDarkMode
                          ? Colors.grey.shade600
                          : Colors.grey.shade300,
                  width: isSelected ? 2 : 1.5,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: Colors.green.withValues(alpha: 0.25),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: isDarkMode ? 0.2 : 0.04),
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
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected
                            ? Colors.white
                            : Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? Colors.white
                          : Colors.transparent,
                      border: Border.all(
                        color: isSelected
                            ? Colors.white
                            : isDarkMode
                                ? Colors.grey.shade500
                                : Colors.grey.shade400,
                        width: 2,
                      ),
                    ),
                    child: isSelected
                        ? const Icon(
                            Icons.check,
                            size: 16,
                            color: Colors.green,
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
