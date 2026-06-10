import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';
import 'package:speak_ez/Constants/app_assets.dart';
import 'package:speak_ez/Constants/app_data.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Controllers/global_controller.dart';

class StreakScreen extends StatefulWidget {
  final int? gems;
  const StreakScreen({super.key, this.gems});

  @override
  State<StreakScreen> createState() => _StreakScreenState();
}

class _StreakScreenState extends State<StreakScreen> {
  static const Color _gold = Color(0xFFF4B740);

  late DateTime _visibleMonth;
  late final Set<DateTime> _streakDates;
  late final DateTime _today;

  // Brightness-derived palette, refreshed at the start of each build.
  late bool _isDark;
  late Color _accent;
  late Color _bandColor;
  late Color _streakDayText;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _visibleMonth = DateTime(now.year, now.month);
    _today = DateTime(now.year, now.month, now.day);
    _streakDates = _buildStreakDates();
  }

  /// Derives the set of completed streak days from the current streak count,
  /// anchored on the user's most recent active day.
  Set<DateTime> _buildStreakDates() {
    final profile = globalController.userProfile.value;
    final streak = profile.currentStreak;
    final dates = <DateTime>{};
    if (streak <= 0) return dates;

    final last = profile.lastActive;
    final anchor = DateTime(last.year, last.month, last.day);
    for (int i = 0; i < streak; i++) {
      dates.add(anchor.subtract(Duration(days: i)));
    }
    return dates;
  }

  /// Saturday-first column index (Sat=0 … Fri=6).
  int _colIndex(DateTime date) => (date.weekday + 1) % 7;

  void _changeMonth(int delta) {
    setState(() {
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month + delta);
    });
  }

  void _share() {
    final streak = globalController.userProfile.value.currentStreak;
    SharePlus.instance.share(
      ShareParams(
        text:
            "🔥 I'm on a $streak day Streak learning English on ${AppStrings.appName}!",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = globalController.userProfile.value;
    final streak = profile.currentStreak;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;

    _isDark = Theme.of(context).brightness == Brightness.dark;
    _accent = _isDark ? const Color(0xFF6F9BFF) : const Color(0xFF3B6FE8);
    _bandColor =
        _isDark ? _gold.withValues(alpha: 0.20) : const Color(0xFFFCEFC7);
    _streakDayText =
        _isDark ? const Color(0xFFFFD27A) : const Color(0xFF9A6B00);

    return Scaffold(
      backgroundColor:
          _isDark ? const Color(0xFF0F1115) : const Color(0xFFEDF3FF),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// --- Header ---
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                    color: textColor,
                  ),
                  Text(
                    AppStrings.currentStreak.tr,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      fontFamily: AppStrings.poppinsFont,
                      color: textColor,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: _share,
                    icon: const Icon(Icons.ios_share, size: 22),
                    color: textColor,
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// --- Gems earned (when arriving from a lesson) ---
                          if (widget.gems != null) ...[
                            const SizedBox(height: 4),
                            _gemsPill(),
                          ],

                          const SizedBox(height: 8),

                          /// --- Big number + fire ---
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "$streak",
                                    style: TextStyle(
                                      fontSize: 64,
                                      height: 1.0,
                                      fontWeight: FontWeight.w800,
                                      color: _accent,
                                      fontFamily: AppStrings.poppinsFont,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    AppStrings.streakDays.tr,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: _accent,
                                      fontFamily: AppStrings.poppinsFont,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              SizedBox(
                                width: 110,
                                height: 110,
                                child: Lottie.asset(
                                  AppAssets.streak,
                                  repeat: true,
                                  decoder: globalController.customDecoder,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          Text(
                            streak > 0
                                ? AppStrings.longestStreakMsg.tr
                                : AppStrings.keepStreakMsg.tr,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              height: 1.35,
                              color: textColor,
                              fontFamily: AppStrings.poppinsFont,
                            ),
                          ),

                          const SizedBox(height: 22),

                          /// --- Milestone badges ---
                          _BadgesRow(streak: streak),

                          const SizedBox(height: 24),
                        ],
                      ),
                    ),

                    /// --- Streak Calendar card ---
                    Container(
                      width: Get.width - 40,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.fromLTRB(20, 22, 20, 28),
                      decoration: BoxDecoration(
                        color:
                            _isDark ? const Color(0xFF1A1D24) : Colors.white,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(28),
                        ),
                      ),
                      child: _buildCalendar(textColor),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gemsPill() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _accent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "${AppStrings.youGot.tr}${widget.gems}",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: _accent,
              fontFamily: AppStrings.poppinsFont,
            ),
          ),
          const SizedBox(width: 6),
          Image.asset(AppAssets.gem, width: 18, height: 18),
        ],
      ),
    );
  }

  Widget _buildCalendar(Color? textColor) {
    final monthName = AppData.monthNames[_visibleMonth.month - 1];
    final headers = ['Sat', 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri'];

    final firstOfMonth = DateTime(_visibleMonth.year, _visibleMonth.month, 1);
    final leadingBlanks = _colIndex(firstOfMonth);
    final daysInMonth =
        DateTime(_visibleMonth.year, _visibleMonth.month + 1, 0).day;

    // Flatten into a list of nullable day numbers.
    final cells = <int?>[
      ...List<int?>.filled(leadingBlanks, null),
      ...List<int?>.generate(daysInMonth, (i) => i + 1),
    ];
    while (cells.length % 7 != 0) {
      cells.add(null);
    }

    final weeks = <List<int?>>[];
    for (int i = 0; i < cells.length; i += 7) {
      weeks.add(cells.sublist(i, i + 7));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.streakCalendar.tr,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: textColor,
            fontFamily: AppStrings.poppinsFont,
          ),
        ),
        const SizedBox(height: 16),

        /// month navigation
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _navButton(Icons.chevron_left, () => _changeMonth(-1)),
            const SizedBox(width: 24),
            SizedBox(
              width: 120,
              child: Text(
                monthName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                  fontFamily: AppStrings.poppinsFont,
                ),
              ),
            ),
            const SizedBox(width: 24),
            _navButton(Icons.chevron_right, () => _changeMonth(1)),
          ],
        ),
        const SizedBox(height: 16),

        /// weekday headers
        Row(
          children: headers
              .map(
                (h) => Expanded(
                  child: Center(
                    child: Text(
                      h,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: textColor?.withValues(alpha: 0.5),
                        fontFamily: AppStrings.poppinsFont,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 8),

        /// day grid
        ...weeks.map((week) => _buildWeekRow(week, textColor)),
      ],
    );
  }

  Widget _buildWeekRow(List<int?> week, Color? textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: List.generate(7, (col) {
          final day = week[col];
          if (day == null) return const Expanded(child: SizedBox(height: 40));

          final date = DateTime(_visibleMonth.year, _visibleMonth.month, day);
          final isStreak = _streakDates.contains(date);
          final isToday = date == _today;
          final isStart =
              isStreak && !_streakDates.contains(date.subtract(const Duration(days: 1)));
          final isEnd =
              isStreak && !_streakDates.contains(date.add(const Duration(days: 1)));

          // Rounded band ends at streak boundaries or at the row edges.
          final roundLeft = isStart || col == 0;
          final roundRight = isEnd || col == 6;
          const radius = Radius.circular(20);

          return Expanded(
            child: SizedBox(
              height: 40,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (isStreak)
                    Container(
                      height: 36,
                      decoration: BoxDecoration(
                        color: _bandColor,
                        borderRadius: BorderRadius.horizontal(
                          left: roundLeft ? radius : Radius.zero,
                          right: roundRight ? radius : Radius.zero,
                        ),
                      ),
                    ),
                  if (isStreak && (isStart || isEnd))
                    Container(
                      width: 34,
                      height: 34,
                      decoration: const BoxDecoration(
                        color: _gold,
                        shape: BoxShape.circle,
                      ),
                    ),
                  if (isToday)
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: _accent, width: 2),
                      ),
                    ),
                  Text(
                    "$day",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isStreak || isToday
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: isStreak && (isStart || isEnd)
                          ? Colors.white
                          : isToday
                              ? _accent
                              : isStreak
                                  ? _streakDayText
                                  : _accent.withValues(alpha: 0.85),
                      fontFamily: AppStrings.poppinsFont,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _navButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
        ),
        child: Icon(icon, size: 20, color: Colors.grey[600]),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// --- MILESTONE BADGES ------------------------------------------------------
/// ---------------------------------------------------------------------------

class _BadgesRow extends StatelessWidget {
  final int streak;
  const _BadgesRow({required this.streak});

  static const List<_Milestone> _milestones = [
    _Milestone(threshold: 3, icon: Icons.bolt),
    _Milestone(threshold: 7, icon: Icons.local_fire_department),
    _Milestone(threshold: 14, icon: Icons.shield_moon),
    _Milestone(threshold: 30, icon: Icons.emoji_events),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: _milestones
          .map((m) => _Badge(icon: m.icon, unlocked: streak >= m.threshold))
          .toList(),
    );
  }
}

class _Milestone {
  final int threshold;
  final IconData icon;
  const _Milestone({required this.threshold, required this.icon});
}

class _Badge extends StatelessWidget {
  final IconData icon;
  final bool unlocked;
  const _Badge({required this.icon, required this.unlocked});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lockedColors = isDark
        ? const [Color(0xFF3A3F4A), Color(0xFF2C313B)]
        : const [Color(0xFFCDD3DC), Color(0xFFB6BDC8)];

    return SizedBox(
      width: 64,
      height: 64,
      child: ClipPath(
        clipper: _HexagonClipper(),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: unlocked
                  ? const [Color(0xFF5B8DEF), Color(0xFF3B6FE8)]
                  : lockedColors,
            ),
          ),
          child: Icon(
            icon,
            size: 28,
            color: unlocked
                ? const Color(0xFFFFD66B)
                : Colors.white.withValues(alpha: isDark ? 0.5 : 0.85),
          ),
        ),
      ),
    );
  }
}

/// Flat-top hexagon.
class _HexagonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;
    return Path()
      ..moveTo(w * 0.25, 0)
      ..lineTo(w * 0.75, 0)
      ..lineTo(w, h * 0.5)
      ..lineTo(w * 0.75, h)
      ..lineTo(w * 0.25, h)
      ..lineTo(0, h * 0.5)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
