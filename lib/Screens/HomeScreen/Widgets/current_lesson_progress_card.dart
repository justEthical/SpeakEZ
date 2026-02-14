import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Constants/app_data.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Controllers/global_controller.dart';
import 'package:speak_ez/Screens/Lessons/lesson_intro_screen.dart';

class CurrentLessonProgressCard extends StatefulWidget {
  final AnimationController? floatingController;

  const CurrentLessonProgressCard({
    super.key,
    this.floatingController,
  });

  @override
  State<CurrentLessonProgressCard> createState() => _CurrentLessonProgressCardState();
}

class _CurrentLessonProgressCardState extends State<CurrentLessonProgressCard>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late AnimationController _buttonController;
  late Animation<double> _progressAnimation;
  late Animation<double> _buttonAnimation;
  double _lastProgress = 0.0;

  @override
  void initState() {
    super.initState();

    _progressController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeOutCubic,
    ));

    _buttonAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _buttonController,
      curve: Curves.elasticOut,
    ));

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _progressController.forward();
    });
  }

  @override
  void dispose() {
    _progressController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  void _animateProgress(double newProgress) {
    if (newProgress > _lastProgress) {
      _buttonController.forward().then((_) {
        _buttonController.reverse();
      });
    }
    _lastProgress = newProgress;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [Theme.of(context).colorScheme.primary, Color(0xFF4A90E2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Obx(() {
                final userProfile = globalController.userProfile.value;
                final lessonNames =
                    AppData.lessonNames[userProfile.currentEnglishLevel] ?? [];
                final progress =
                    lessonNames.isNotEmpty
                        ? (userProfile.currentEnglishLevelProgress /
                            lessonNames.length)
                        : 0.0;

                _animateProgress(progress);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${AppStrings.currentLevel.tr}: ${userProfile.currentEnglishLevel}",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: AppStrings.nunitoFont,
                        fontWeight: FontWeight.w700,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      lessonNames.isNotEmpty
                          ? lessonNames[userProfile.currentEnglishLevelProgress]
                          : AppStrings.introduction.tr,
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: AppStrings.nunitoFont,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: AnimatedBuilder(
                              animation: _progressAnimation,
                              builder: (context, child) {
                                return LinearProgressIndicator(
                                  value: progress * _progressAnimation.value,
                                  minHeight: 10,
                                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white.withValues(alpha: 0.9),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        AnimatedBuilder(
                          animation: _progressAnimation,
                          builder: (context, child) {
                            final animatedProgress = progress * _progressAnimation.value * 100;
                            return TweenAnimationBuilder<double>(
                              duration: const Duration(milliseconds: 500),
                              tween: Tween(begin: 0.0, end: animatedProgress),
                              builder: (context, value, child) {
                                return Text(
                                  "${value.toStringAsFixed(0)}%",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: AppStrings.nunitoFont,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    AnimatedBuilder(
                      animation: _buttonAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _buttonAnimation.value,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () async {
                                _buttonController.forward().then((_) {
                                  _buttonController.reverse();
                                });
                                await Future.delayed(const Duration(milliseconds: 300));
                                Get.to(() => LessonIntroScreen());
                              },
                              borderRadius: BorderRadius.circular(15),
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.1),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    progress == 0.0 ? 'startLearning'.tr : 'continueLearning'.tr,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: AppStrings.nunitoFont,
                                      fontWeight: FontWeight.w800,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              }),
            ),
    );
  }
}