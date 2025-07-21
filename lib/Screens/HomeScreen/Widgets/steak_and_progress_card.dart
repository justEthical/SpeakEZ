import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class SteakAndProgressCard extends StatelessWidget {
  final String title;
  final String icon;
  final Color iconColor;
  final String progress;

  const SteakAndProgressCard({
    super.key,
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(icon, color: iconColor, width: 30, height: 30),
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
                color: iconColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}