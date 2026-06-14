import 'package:flutter/material.dart';

/// Colour palette for the home screen, modelled on the Stitch "Home Screen –
/// Dark Mode" design and given sensible light-mode equivalents so the screen
/// still reads correctly under either theme.
class HomePalette {
  final bool isDark;
  HomePalette(BuildContext context)
      : isDark = Theme.of(context).brightness == Brightness.dark;

  Color get background =>
      isDark ? const Color(0xFF091421) : const Color(0xFFF5F6FA);

  Color get cardColor =>
      isDark ? const Color(0xFF16202E) : Colors.white;

  Color get cardBorder => isDark
      ? Colors.white.withValues(alpha: 0.06)
      : Colors.black.withValues(alpha: 0.05);

  Color get onSurface =>
      isDark ? const Color(0xFFD9E3F6) : const Color(0xFF1A1C1E);

  Color get onSurfaceVariant =>
      isDark ? const Color(0xFFB7BECC) : const Color(0xFF5A5D63);

  Color get primary =>
      isDark ? const Color(0xFFC9B2FF) : const Color(0xFF7C3AED);

  Color get secondary =>
      isDark ? const Color(0xFFFFB95F) : const Color(0xFFEE9800);

  Color get tertiary =>
      isDark ? const Color(0xFFFFB784) : const Color(0xFFC2410C);

  Color get pillColor =>
      isDark ? const Color(0xFF212B39) : const Color(0xFFEDEFF3);

  Color get progressTrack => isDark
      ? Colors.white.withValues(alpha: 0.12)
      : Colors.black.withValues(alpha: 0.08);

  /// Purple → indigo gradient used by the main learning card.
  List<Color> get mainGradient =>
      const [Color(0xFF7C3AED), Color(0xFF4338CA)];

  /// Solid purple used for text on the white CTA button (needs contrast in
  /// both themes).
  Color get onCtaButton => const Color(0xFF6D28D9);

  BoxDecoration glassCard({Color? leftBorder, double radius = 16}) {
    return BoxDecoration(
      color: cardColor,
      borderRadius: BorderRadius.circular(radius),
      border: leftBorder != null
          ? Border(left: BorderSide(color: leftBorder, width: 4))
          : Border.all(color: cardBorder),
      boxShadow: isDark
          ? const [
              BoxShadow(
                color: Color(0x33000000),
                blurRadius: 24,
                offset: Offset(0, 8),
              ),
            ]
          : [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
    );
  }
}
