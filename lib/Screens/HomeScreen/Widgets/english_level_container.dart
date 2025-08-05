import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speak_ez/Screens/HomeScreen/list_of_lessons.dart';

class EnglishLevelContainer extends StatelessWidget {
  final String level;
  final int lessons;
  final Color color;
  final bool isLocked;

  const EnglishLevelContainer({
    super.key,
    required this.level,
    required this.lessons,
    required this.color,
    this.isLocked = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLocked ? null : () => Get.to(() => const ListOfLessons()),
      child: Container(
        width: 100, // Fixed width for horizontal scrolling
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.8),
              color,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            if (!isLocked)
              BoxShadow(
                color: color.withOpacity(0.4),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  level,
                  style: GoogleFonts.nunito(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                if (isLocked)
                  const Icon(Icons.lock, color: Colors.white70, size: 20),
              ],
            ),
            Text(
              "$lessons Lessons",
              style: GoogleFonts.nunito(
                color: Colors.white.withOpacity(0.9),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}