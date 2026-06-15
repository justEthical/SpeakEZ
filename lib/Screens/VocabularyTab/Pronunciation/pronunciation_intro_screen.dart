import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Constants/app_data.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Controllers/vocabulary_tab_controller.dart';
import 'package:speak_ez/Screens/VocabularyTab/Pronunciation/category_screen.dart';
import 'package:speak_ez/Services/posthog_service.dart';

/// Fluent Flow palette, adaptive to light / dark mode.
class _Palette {
  final Color bg;
  final Color card;
  final Color border;
  final Color title;
  final Color desc;
  final Color open;
  final List<BoxShadow> cardShadow;

  const _Palette({
    required this.bg,
    required this.card,
    required this.border,
    required this.title,
    required this.desc,
    required this.open,
    required this.cardShadow,
  });

  static const _dark = _Palette(
    bg: Color(0xFF091421),
    card: Color(0xCC121C2A), // rgba(18,28,42,0.8)
    border: Color(0x14FFFFFF), // white @ 8%
    title: Colors.white,
    desc: Color(0xFF9CA3AF), // gray-400
    open: Color(0xFFD1D5DB), // gray-300
    cardShadow: [],
  );

  static const _light = _Palette(
    bg: Color(0xFFF8FAFC), // slate-50
    card: Colors.white,
    border: Color(0xFFE5E7EB), // gray-200
    title: Color(0xFF0F172A), // slate-900
    desc: Color(0xFF6B7280), // gray-500
    open: Color(0xFF475569), // slate-600
    cardShadow: [
      BoxShadow(
        color: Color(0x0F000000),
        blurRadius: 10,
        offset: Offset(0, 4),
      ),
    ],
  );

  static _Palette of(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? _dark : _light;
}

/// Per-card accent: icon chip background tint + icon glyph + colour.
class _LevelStyle {
  final IconData icon;
  final Color color;
  const _LevelStyle(this.icon, this.color);
}

const List<_LevelStyle> _levelStyles = [
  _LevelStyle(Icons.flight_land, Color(0xFF60A5FA)), // blue
  _LevelStyle(Icons.navigation, Color(0xFFC084FC)), // purple
  _LevelStyle(Icons.business_center, Color(0xFF2DD4BF)), // teal
  _LevelStyle(Icons.groups, Color(0xFFFB923C)), // orange
  _LevelStyle(Icons.psychology, Color(0xFFF472B6)), // pink
  _LevelStyle(Icons.theater_comedy, Color(0xFF818CF8)), // indigo
];

class PronunciationIntroScreen extends StatefulWidget {
  /// When shown as a bottom-tab destination there is nothing to pop back to,
  /// so the leading back button is hidden.
  final bool showBackButton;
  const PronunciationIntroScreen({super.key, this.showBackButton = true});

  @override
  State<PronunciationIntroScreen> createState() =>
      _PronunciationIntroScreenState();
}

class _PronunciationIntroScreenState extends State<PronunciationIntroScreen> {
  final c = Get.put(VocabularyTabController());

  static const Set<String> _unlockedLevels = {'A1', 'A2', 'B1', 'B2', 'C1', 'C2'};

  bool _isLevelUnlocked(String levelCode) =>
      _unlockedLevels.contains(levelCode);

  void _showComingSoonToast() {
    Fluttertoast.showToast(msg: 'Coming soon');
  }

  /// Adaptive tile height so titles/subtitles never clip on narrow screens or
  /// with larger OS font scales. Grows with the (clamped) text scale instead of
  /// relying on a fixed aspect ratio.
  double _tileExtent(BuildContext context) {
    final media = MediaQuery.of(context);
    final textScale = media.textScaler.scale(1.0).clamp(1.0, 1.4);
    // Horizontal padding 24*2 + crossAxisSpacing 16.
    final cardWidth = (media.size.width - 48 - 16) / 2;
    // Fixed chrome: padding(40) + icon(40) + gap(16) + gap(8) + gap(12)
    // + footer row(~18).
    const chrome = 40 + 40 + 16 + 8 + 12 + 18;
    final titleHeight = 2 * 17 * 1.1 * textScale;
    final subtitleHeight = 3 * 12 * 1.35 * textScale;
    return (chrome + titleHeight + subtitleHeight)
        .clamp(cardWidth / 0.82, double.infinity);
  }

  @override
  Widget build(BuildContext context) {
    PostHogService.instance.captureScreenView('pronunciation_intro_screen');
    final p = _Palette.of(context);
    final levels = AppData.englishVobularyLevels.entries.toList();

    return Scaffold(
      backgroundColor: p.bg,
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   automaticallyImplyLeading: false,
      //   leading: widget.showBackButton
      //       ? IconButton(
      //           onPressed: () => Get.back(),
      //           icon: const Icon(
      //             Icons.arrow_back_ios_new_rounded,
      //             color: Colors.white,
      //           ),
      //         )
      //       : null,
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(24, 4, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.vocabularyBuilder.tr,
                style: TextStyle(
                  color: p.title,
                  fontFamily: AppStrings.nunitoFont,
                  fontWeight: FontWeight.w800,
                  fontSize: 30,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                AppStrings.vocabPickEraSubtitle.tr,
                style: TextStyle(
                  color: p.desc,
                  fontFamily: AppStrings.nunitoFont,
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 20),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: levels.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  mainAxisExtent: _tileExtent(context),
                ),
                itemBuilder: (context, index) {
                  final entry = levels[index];
                  final levelCode = entry.key;
                  final isUnlocked = _isLevelUnlocked(levelCode);
                  final style = _levelStyles[index % _levelStyles.length];
                  return _LevelTile(
                    title: entry.value['title'] as String,
                    subtitle: entry.value['subtitle'] as String,
                    style: style,
                    palette: p,
                    isLocked: !isUnlocked,
                    onTap: () {
                      if (!isUnlocked) {
                        _showComingSoonToast();
                        return;
                      }
                      Get.to(CategoryScreen(levelCode: levelCode));
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LevelTile extends StatelessWidget {
  const _LevelTile({
    required this.title,
    required this.subtitle,
    required this.style,
    required this.palette,
    required this.isLocked,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final _LevelStyle style;
  final _Palette palette;
  final bool isLocked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Opacity(
          opacity: isLocked ? 0.7 : 1,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: palette.card,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: palette.border, width: 1),
              boxShadow: palette.cardShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: style.color.withValues(alpha: 0.20),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(style.icon, color: style.color, size: 22),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: palette.title,
                    fontFamily: AppStrings.nunitoFont,
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Text(
                    subtitle,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: palette.desc,
                      fontFamily: AppStrings.nunitoFont,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      height: 1.35,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      isLocked ? 'Coming soon' : 'Open',
                      style: TextStyle(
                        color: palette.open,
                        fontFamily: AppStrings.nunitoFont,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      isLocked
                          ? Icons.lock_rounded
                          : Icons.arrow_forward_rounded,
                      size: 16,
                      color: palette.desc,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
