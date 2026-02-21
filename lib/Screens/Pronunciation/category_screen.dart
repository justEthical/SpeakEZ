import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Controllers/vocabulary_tab_controller.dart';
import 'package:speak_ez/Models/pronunciation_word_model.dart';

// ─── Section data ─────────────────────────────────────────────────────────────

class _SectionData {
  final String categoryName;
  final List<String> topics;
  final Color accent;
  final int startDay;

  const _SectionData({
    required this.categoryName,
    required this.topics,
    required this.accent,
    required this.startDay,
  });
}

// ─── Screen ───────────────────────────────────────────────────────────────────

class CategoryScreen extends StatefulWidget {
  final String levelCode;
  const CategoryScreen({super.key, required this.levelCode});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  static const Color _ink = Color(0xFF101828);
  static const Color _surface = Color(0xFFF7F8FC);

  static const List<Color> _palette = [
    Color(0xFF0EA5E9),
    Color(0xFF10B981),
    Color(0xFFF59E0B),
    Color(0xFF8B5CF6),
    Color(0xFFEF4444),
  ];

  final c = Get.find<VocabularyTabController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      c.loadLevelData(widget.levelCode);
    });
  }

  List<_SectionData> _buildSections(List<Category> categories) {
    final sections = <_SectionData>[];
    int day = 1;
    for (int i = 0; i < categories.length; i++) {
      final cat = categories[i];
      sections.add(_SectionData(
        categoryName: cat.categoryName,
        topics: cat.topics,
        accent: _palette[i % _palette.length],
        startDay: day,
      ));
      day += cat.topics.length;
    }
    return sections;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: _ink),
        ),
        title: Text(
          widget.levelCode,
          style: const TextStyle(
            color: _ink,
            fontFamily: AppStrings.nunitoFont,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: Obx(() {
        final level = c.currentEnglishVocabLevel.value;

        if (level.categories.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final sections = _buildSections(level.categories);

        return CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      level.title,
                      style: const TextStyle(
                        color: _ink,
                        fontFamily: AppStrings.nunitoFont,
                        fontWeight: FontWeight.w900,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      level.subtitle,
                      style: TextStyle(
                        color: _ink.withValues(alpha: 0.5),
                        fontFamily: AppStrings.nunitoFont,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        _Pill('${level.metadata.totalTopics} days'),
                        const SizedBox(width: 8),
                        _Pill('${level.metadata.totalCategories} sections'),
                        const SizedBox(width: 8),
                        _Pill('${level.metadata.totalWords} words'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Sections
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 36),
              sliver: SliverList.separated(
                itemCount: sections.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) =>
                    _SectionCard(section: sections[index]),
              ),
            ),
          ],
        );
      }),
    );
  }
}

// ─── Pill ─────────────────────────────────────────────────────────────────────

class _Pill extends StatelessWidget {
  const _Pill(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFF2563EB).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF1D4ED8),
          fontFamily: AppStrings.nunitoFont,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}

// ─── Section card (collapsible) ───────────────────────────────────────────────

class _SectionCard extends StatefulWidget {
  const _SectionCard({required this.section});
  final _SectionData section;

  @override
  State<_SectionCard> createState() => _SectionCardState();
}

class _SectionCardState extends State<_SectionCard> {
  bool _expanded = true;

  _SectionData get s => widget.section;

  int get _endDay => s.startDay + s.topics.length - 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.045),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Section header (always visible) ──────────────────────────
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => setState(() => _expanded = !_expanded),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: s.accent,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            s.categoryName,
                            style: const TextStyle(
                              color: Color(0xFF111827),
                              fontFamily: AppStrings.nunitoFont,
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Days ${s.startDay}–$_endDay  ·  ${s.topics.length} topics',
                            style: TextStyle(
                              color: const Color(0xFF6B7280).withValues(alpha: 0.9),
                              fontFamily: AppStrings.nunitoFont,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AnimatedRotation(
                      turns: _expanded ? 0 : -0.25,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOutCubic,
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: s.accent.withValues(alpha: 0.8),
                        size: 22,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Collapsible body ──────────────────────────────────────────
            AnimatedSize(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOutCubic,
              child: _expanded
                  ? Column(
                      children: [
                        Divider(
                          height: 1,
                          thickness: 1,
                          color: s.accent.withValues(alpha: 0.10),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                          child: Column(
                            children: [
                              for (int i = 0; i < s.topics.length; i++)
                                _TopicRow(
                                  dayNumber: s.startDay + i,
                                  topicName: s.topics[i],
                                  accent: s.accent,
                                  showLine: i < s.topics.length - 1,
                                ),
                            ],
                          ),
                        ),
                        _MilestoneBanner(
                          categoryName: s.categoryName,
                          topicCount: s.topics.length,
                          accent: s.accent,
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Topic row ────────────────────────────────────────────────────────────────

class _TopicRow extends StatelessWidget {
  const _TopicRow({
    required this.dayNumber,
    required this.topicName,
    required this.accent,
    required this.showLine,
  });

  final int dayNumber;
  final String topicName;
  final Color accent;
  final bool showLine;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline track
          SizedBox(
            width: 40,
            child: Column(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.10),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: accent.withValues(alpha: 0.35),
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '$dayNumber',
                      style: TextStyle(
                        color: accent,
                        fontFamily: AppStrings.nunitoFont,
                        fontWeight: FontWeight.w800,
                        fontSize: dayNumber >= 10 ? 10 : 12,
                      ),
                    ),
                  ),
                ),
                if (showLine)
                  Expanded(
                    child: Center(
                      child: Container(
                        width: 2,
                        color: accent.withValues(alpha: 0.15),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // Row content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Day $dayNumber',
                            style: TextStyle(
                              color: accent,
                              fontFamily: AppStrings.nunitoFont,
                              fontWeight: FontWeight.w700,
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            topicName,
                            style: const TextStyle(
                              color: Color(0xFF111827),
                              fontFamily: AppStrings.nunitoFont,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 12,
                      color: const Color(0xFF9CA3AF).withValues(alpha: 0.7),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Milestone banner ─────────────────────────────────────────────────────────

class _MilestoneBanner extends StatelessWidget {
  const _MilestoneBanner({
    required this.categoryName,
    required this.topicCount,
    required this.accent,
  });

  final String categoryName;
  final int topicCount;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: accent.withValues(alpha: 0.20),
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.flag_rounded, color: accent, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              categoryName,
              style: TextStyle(
                color: accent,
                fontFamily: AppStrings.nunitoFont,
                fontWeight: FontWeight.w800,
                fontSize: 13,
              ),
            ),
          ),
          Text(
            '$topicCount topics done',
            style: TextStyle(
              color: accent.withValues(alpha: 0.7),
              fontFamily: AppStrings.nunitoFont,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}