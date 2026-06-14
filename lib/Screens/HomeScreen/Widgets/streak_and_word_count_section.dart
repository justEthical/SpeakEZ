import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Controllers/global_controller.dart';
import 'package:speak_ez/Screens/HomeScreen/Widgets/home_palette.dart';
import 'package:speak_ez/Screens/HomeScreen/streak_screen.dart';

class StreakAndWordCountSection extends StatelessWidget {
  const StreakAndWordCountSection({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = HomePalette(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Obx(
        () => Row(
          children: [
            Expanded(
              child: _StatCard(
                palette: palette,
                icon: Icons.local_fire_department,
                accent: palette.secondary,
                value:
                    "${globalController.userProfile.value.currentStreak} ${AppStrings.days.tr}",
                label: AppStrings.currentStreak.tr,
                onTap: () => Get.to(() => const StreakScreen()),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                palette: palette,
                icon: Icons.school,
                accent: palette.primary,
                value: "${globalController.userProfile.value.wordLearned}",
                label: AppStrings.wordsLearned.tr,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final HomePalette palette;
  final IconData icon;
  final Color accent;
  final String value;
  final String label;
  final VoidCallback? onTap;

  const _StatCard({
    required this.palette,
    required this.icon,
    required this.accent,
    required this.value,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        decoration: palette.glassCard(),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accent.withValues(alpha: 0.15),
              ),
              child: Icon(icon, color: accent, size: 26),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontFamily: AppStrings.nunitoFont,
                fontWeight: FontWeight.w800,
                color: accent,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                letterSpacing: 0.5,
                fontFamily: AppStrings.nunitoFont,
                fontWeight: FontWeight.w600,
                color: palette.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
