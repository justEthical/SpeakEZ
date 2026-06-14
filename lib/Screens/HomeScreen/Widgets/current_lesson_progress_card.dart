import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Constants/app_data.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Controllers/global_controller.dart';
import 'package:speak_ez/Screens/HomeScreen/Widgets/home_palette.dart';
import 'package:speak_ez/Screens/Lessons/lesson_intro_screen.dart';

class CurrentLessonProgressCard extends StatelessWidget {
  const CurrentLessonProgressCard({super.key});

  String _tierFor(String level) {
    if (level.startsWith('A')) return AppStrings.tierBeginner.tr;
    if (level.startsWith('B')) return AppStrings.tierIntermediate.tr;
    return AppStrings.tierAdvanced.tr;
  }

  @override
  Widget build(BuildContext context) {
    final palette = HomePalette(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: palette.mainGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: palette.mainGradient.first.withValues(alpha: 0.35),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Obx(() {
          final userProfile = globalController.userProfile.value;
          final level = userProfile.currentEnglishLevel;
          final lessonNames = AppData.lessonNames[level] ?? [];
          final progressIndex = userProfile.currentEnglishLevelProgress;
          final progress = lessonNames.isNotEmpty
              ? (progressIndex / lessonNames.length).clamp(0.0, 1.0)
              : 0.0;
          final lessonName = (lessonNames.isNotEmpty &&
                  progressIndex < lessonNames.length)
              ? lessonNames[progressIndex]
              : AppStrings.introduction.tr;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.22),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _tierFor(level),
                            style: const TextStyle(
                              fontSize: 12,
                              fontFamily: AppStrings.nunitoFont,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "${AppStrings.currentLevel.tr}: $level",
                          style: const TextStyle(
                            fontSize: 20,
                            fontFamily: AppStrings.nunitoFont,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          lessonName,
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: AppStrings.nunitoFont,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                    ),
                    child: const Icon(
                      Icons.play_circle_outline,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.courseProgress.tr,
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: AppStrings.nunitoFont,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  Text(
                    "${(progress * 100).toStringAsFixed(0)}%",
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: AppStrings.nunitoFont,
                      fontWeight: FontWeight.w700,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 900),
                  curve: Curves.easeOutCubic,
                  tween: Tween(begin: 0.0, end: progress),
                  builder: (context, value, _) => LinearProgressIndicator(
                    value: value,
                    minHeight: 10,
                    backgroundColor: Colors.black.withValues(alpha: 0.2),
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => Get.to(() => LessonIntroScreen()),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.bolt, color: palette.onCtaButton, size: 20),
                        const SizedBox(width: 6),
                        Text(
                          progress == 0.0
                              ? AppStrings.startLearning.tr
                              : AppStrings.continueLearning.tr,
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: AppStrings.nunitoFont,
                            fontWeight: FontWeight.w800,
                            color: palette.onCtaButton,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
