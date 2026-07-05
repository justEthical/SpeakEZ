import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Controllers/placement_controller.dart';
import 'package:speak_ez/Screens/OnBoarding/Placement/placement_words_screen.dart';
import 'package:speak_ez/Screens/OnBoarding/preparing_screen.dart';

class PlacementIntroScreen extends StatelessWidget {
  const PlacementIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Owns the controller for the whole placement flow.
    final c = Get.put(PlacementController());
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 2),
              Text(
                'Let’s find your level',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontFamily: AppStrings.nunitoFont,
                  fontWeight: FontWeight.w800,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Tap the words you know — there are no wrong answers. '
                'We’ll use this to personalize your lessons.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: AppStrings.nunitoFont,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                  color: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.color
                      ?.withValues(alpha: 0.7),
                ),
              ),
              const Spacer(flex: 3),
              ElevatedButton(
                onPressed: () => Get.to(() => const PlacementWordsScreen()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  'Start',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: AppStrings.nunitoFont,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  // Skip → treat as absolute beginner (preserves old default).
                  c.persistLevel('A1');
                  Get.offAll(() => const PreparingScreen());
                },
                child: Text(
                  'I’m a total beginner',
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: AppStrings.nunitoFont,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.color
                        ?.withValues(alpha: 0.6),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
