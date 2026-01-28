import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:speak_ez/Constants/app_assets.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Controllers/global_controller.dart';
import 'package:speak_ez/Screens/tab_bar_screen.dart';

class PreparingScreen extends StatefulWidget {
  const PreparingScreen({super.key});

  @override
  State<PreparingScreen> createState() => _PreparingScreenState();
}

class _PreparingScreenState extends State<PreparingScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _pulseController;
  late AnimationController _dotController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _pulseAnimation;

  int _currentDotCount = 0;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _dotController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            _currentDotCount = (_currentDotCount + 1) % 4;
          });
          _dotController.reset();
          _dotController.forward();
        }
      });

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _fadeController.forward();
    _dotController.forward();

    // Navigate to main screen after 2.5 seconds
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        Get.offAll(() => const TabBarScreen());
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _pulseController.dispose();
    _dotController.dispose();
    super.dispose();
  }

  String _getDots() {
    return '.' * _currentDotCount;
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).scaffoldBackgroundColor,
              primaryColor.withValues(alpha: 0.1),
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),
                // Animated Lottie
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _pulseAnimation.value,
                      child: Container(
                        width: Get.width * 0.6,
                        height: Get.width * 0.6,
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(Get.width * 0.3),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Lottie.asset(
                            AppAssets.chatting,
                            decoder: globalController.customDecoder,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 50),
                // Main title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    'preparingTitle'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: AppStrings.nunitoFont,
                      fontWeight: FontWeight.w800,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Subtitle with animated dots
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'preparingSubtitle'.tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: AppStrings.nunitoFont,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.color
                              ?.withValues(alpha: 0.7),
                        ),
                      ),
                      SizedBox(
                        width: 24,
                        child: Text(
                          _getDots(),
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: AppStrings.nunitoFont,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.color
                                ?.withValues(alpha: 0.7),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(flex: 2),
                // Progress indicator
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 60),
                  child: TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 2500),
                    tween: Tween(begin: 0.0, end: 1.0),
                    builder: (context, value, child) {
                      return Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: value,
                              minHeight: 6,
                              backgroundColor: primaryColor.withValues(alpha: 0.2),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                primaryColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '${(value * 100).toInt()}%',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: AppStrings.nunitoFont,
                              fontWeight: FontWeight.w600,
                              color: primaryColor,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
