import 'package:flutter/material.dart';
import 'package:speak_ez/Constants/app_strings.dart';

class PronunciationScoreChip extends StatelessWidget {
  const PronunciationScoreChip({
    super.key,
    required this.score,
    required this.band,
  });

  final double score;
  final String band;

  @override
  Widget build(BuildContext context) {
    Color bg;
    if (score >= 90) {
      bg = const Color(0xFF16A34A);
    } else if (score >= 75) {
      bg = const Color(0xFF15803D);
    } else if (score >= 60) {
      bg = const Color(0xFFD97706);
    } else {
      bg = const Color(0xFFDC2626);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '${score.toStringAsFixed(0)} • $band',
        style: const TextStyle(
          color: Colors.white,
          fontFamily: AppStrings.nunitoFont,
          fontWeight: FontWeight.w700,
          fontSize: 13,
        ),
      ),
    );
  }
}
