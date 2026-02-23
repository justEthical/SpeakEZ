import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Controllers/vocabulary_tab_controller.dart';
import 'package:speak_ez/Models/pronunciation_word_model.dart';
import 'package:speak_ez/Screens/VocabularyTab/Pronunciation/topic_words_screen.dart';

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
      c.loadVocabProgress();
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
    final ink = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: ink),
        ),
        title: Text(
          widget.levelCode,
          style: TextStyle(
            color: ink,
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
                      style: TextStyle(
                        color: ink,
                        fontFamily: AppStrings.nunitoFont,
                        fontWeight: FontWeight.w900,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      level.subtitle,
                      style: TextStyle(
                        color: ink.withValues(alpha: 0.5),
                        fontFamily: AppStrings.nunitoFont,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        _Pill('${level.metadata.totalTopics} ${AppStrings.vocabDays.tr}'),
                        const SizedBox(width: 8),
                        _Pill('${level.metadata.totalCategories} ${AppStrings.vocabTopics.tr}'),
                        const SizedBox(width: 8),
                        _Pill('${level.metadata.totalWords} ${AppStrings.vocabulary.tr}'),
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
                itemBuilder: (context, index) => _SectionCard(
                  section: sections[index],
                  levelCode: widget.levelCode,
                ),
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
  const _SectionCard({required this.section, required this.levelCode});
  final _SectionData section;
  final String levelCode;

  @override
  State<_SectionCard> createState() => _SectionCardState();
}

class _SectionCardState extends State<_SectionCard> {
  bool _expanded = true;

  _SectionData get s => widget.section;

  int get _endDay => s.startDay + s.topics.length - 1;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = Theme.of(context).colorScheme.onSecondary;
    final ink = Theme.of(context).colorScheme.onSurface;

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.045),
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
                            style: TextStyle(
                              color: ink,
                              fontFamily: AppStrings.nunitoFont,
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${AppStrings.vocabDays.tr} ${s.startDay}–$_endDay  ·  ${s.topics.length} ${AppStrings.vocabTopics.tr}',
                            style: TextStyle(
                              color: ink.withValues(alpha: 0.45),
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
                                  levelCode: widget.levelCode,
                                  categoryName: s.categoryName,
                                ),
                            ],
                          ),
                        ),
                        _MilestoneBanner(
                          categoryName: s.categoryName,
                          topicCount: s.topics.length,
                          topics: s.topics,
                          levelCode: widget.levelCode,
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
  _TopicRow({
    required this.dayNumber,
    required this.topicName,
    required this.accent,
    required this.showLine,
    required this.levelCode,
    required this.categoryName,
  });

  final int dayNumber;
  final String topicName;
  final Color accent;
  final bool showLine;
  final String levelCode;
  final String categoryName;

  final _c = Get.find<VocabularyTabController>();

  @override
  Widget build(BuildContext context) {
    final ink = Theme.of(context).colorScheme.onSurface;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline track
          SizedBox(
            width: 40,
            child: Column(
              children: [
                Obx(() {
                  final completed = _c.isTopicCompleted(
                    levelCode,
                    categoryName,
                    topicName,
                  );
                  return Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: completed
                          ? const Color(0xFF10B981)
                          : accent.withValues(alpha: 0.10),
                      shape: BoxShape.circle,
                      border: completed
                          ? null
                          : Border.all(
                              color: accent.withValues(alpha: 0.35),
                              width: 1.5,
                            ),
                    ),
                    child: Center(
                      child: completed
                          ? const Icon(
                              Icons.check_rounded,
                              color: Colors.white,
                              size: 18,
                            )
                          : Text(
                              '$dayNumber',
                              style: TextStyle(
                                color: accent,
                                fontFamily: AppStrings.nunitoFont,
                                fontWeight: FontWeight.w800,
                                fontSize: dayNumber >= 10 ? 10 : 12,
                              ),
                            ),
                    ),
                  );
                }),
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
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Get.to(
                () => TopicWordsScreen(
                  levelCode: levelCode,
                  categoryName: categoryName,
                  topicName: topicName,
                  accent: accent,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${AppStrings.vocabDay.tr} $dayNumber',
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
                            style: TextStyle(
                              color: ink,
                              fontFamily: AppStrings.nunitoFont,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Obx(() {
                      final result = _c.getTopicResult(
                        levelCode,
                        categoryName,
                        topicName,
                      );
                      if (result != null) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981)
                                  .withValues(alpha: 0.10),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${result.perfectCount}/${result.totalWords}',
                              style: const TextStyle(
                                color: Color(0xFF10B981),
                                fontFamily: AppStrings.nunitoFont,
                                fontWeight: FontWeight.w700,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 12,
                      color: ink.withValues(alpha: 0.3),
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
  _MilestoneBanner({
    required this.categoryName,
    required this.topicCount,
    required this.topics,
    required this.levelCode,
    required this.accent,
  });

  final String categoryName;
  final int topicCount;
  final List<String> topics;
  final String levelCode;
  final Color accent;

  final _c = Get.find<VocabularyTabController>();

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
          Obx(() {
            final done = _c.completedTopicsInCategory(
              levelCode,
              categoryName,
              topics,
            );
            return Text(
              '$done / $topicCount ${AppStrings.vocabTopicsDone.tr}',
              style: TextStyle(
                color: accent.withValues(alpha: 0.7),
                fontFamily: AppStrings.nunitoFont,
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
            );
          }),
        ],
      ),
    );
  }
}
