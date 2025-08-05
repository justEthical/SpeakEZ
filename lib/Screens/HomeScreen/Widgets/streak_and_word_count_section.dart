import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speak_ez/Constants/app_assets.dart';
import 'package:speak_ez/Controllers/global_controller.dart';

class StreakAndWordCountSection extends StatelessWidget {
  const StreakAndWordCountSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => Row(
              children: [
                Obx(
                  () => _buildProgressCard(
                    context,
                    title: "Current Streak",
                    icon: AppAssets.flame,
                    progress:
                        "${globalController.userProfile.value.currentStreak} days",
                    color: Colors.deepOrange,
                  ),
                ),
                const SizedBox(width: 20),
                _buildProgressCard(
                  context,
                  title: "Words Learned",
                  icon: AppAssets.medal,
                  progress:
                      "${globalController.userProfile.value.wordLearned}", // Hardcoded value
                  color: Colors.deepPurple,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(
    BuildContext context, {
    required String title,
    required String icon,
    required String progress,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(icon, color: color, width: 30, height: 30),
            const SizedBox(height: 15),
            Text(
              title,
              style: GoogleFonts.nunito(
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              progress,
              style: GoogleFonts.nunito(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}