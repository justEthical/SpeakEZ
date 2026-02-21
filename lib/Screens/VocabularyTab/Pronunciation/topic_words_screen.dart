import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Controllers/vocabulary_tab_controller.dart';
import 'package:speak_ez/Models/pronunciation_word_model.dart';

class TopicWordsScreen extends StatefulWidget {
  final String levelCode;
  final String categoryName;
  final String topicName;
  final Color accent;

  const TopicWordsScreen({
    super.key,
    required this.levelCode,
    required this.categoryName,
    required this.topicName,
    required this.accent,
  });

  @override
  State<TopicWordsScreen> createState() => _TopicWordsScreenState();
}

class _TopicWordsScreenState extends State<TopicWordsScreen> {
  static const Color _ink = Color(0xFF101828);
  static const Color _surface = Color(0xFFF7F8FC);

  final _controller = Get.find<VocabularyTabController>();
  final _pageController = PageController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.loadTopicWords(
        widget.levelCode,
        widget.categoryName,
        widget.topicName,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goTo(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.topicName,
              style: const TextStyle(
                color: _ink,
                fontFamily: AppStrings.nunitoFont,
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
            Text(
              widget.levelCode,
              style: TextStyle(
                color: _ink.withValues(alpha: 0.45),
                fontFamily: AppStrings.nunitoFont,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      body: Obx(() {
        if (_controller.isLoadingTopicWords.value) {
          return Center(
            child: CircularProgressIndicator(color: widget.accent),
          );
        }

        final words = _controller.currentTopicWords.value.words;

        if (words.isEmpty) {
          return Center(
            child: Text(
              'No words found for this topic.',
              style: TextStyle(
                color: _ink.withValues(alpha: 0.5),
                fontFamily: AppStrings.nunitoFont,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        }

        return Column(
          children: [
            // Progress bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: (_currentIndex + 1) / words.length,
                        backgroundColor: widget.accent.withValues(alpha: 0.12),
                        color: widget.accent,
                        minHeight: 5,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${_currentIndex + 1} / ${words.length}',
                    style: TextStyle(
                      color: widget.accent,
                      fontFamily: AppStrings.nunitoFont,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            // Word cards
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: words.length,
                onPageChanged: (i) => setState(() => _currentIndex = i),
                itemBuilder: (context, i) =>
                    _WordCard(word: words[i], accent: widget.accent),
              ),
            ),

            // Navigation buttons
            _BottomNav(
              currentIndex: _currentIndex,
              total: words.length,
              accent: widget.accent,
              onPrev: () => _goTo(_currentIndex - 1),
              onNext: () => _goTo(_currentIndex + 1),
              onDone: () => Get.back(),
            ),
          ],
        );
      }),
    );
  }
}

// ─── Word card ────────────────────────────────────────────────────────────────

class _WordCard extends StatelessWidget {
  const _WordCard({required this.word, required this.accent});

  final VocabWord word;
  final Color accent;

  static const Color _ink = Color(0xFF101828);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Word + phonetic
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  word.word,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: accent,
                    fontFamily: AppStrings.nunitoFont,
                    fontWeight: FontWeight.w900,
                    fontSize: 40,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  word.phoneticRespelling,
                  style: TextStyle(
                    color: _ink.withValues(alpha: 0.4),
                    fontFamily: AppStrings.nunitoFont,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    word.translation,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: accent,
                      fontFamily: AppStrings.nunitoFont,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Definition
          _InfoBlock(
            label: 'Definition',
            accent: accent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  word.definition,
                  style: const TextStyle(
                    color: _ink,
                    fontFamily: AppStrings.nunitoFont,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                if (word.definationTranslation.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    word.definationTranslation,
                    style: TextStyle(
                      color: _ink.withValues(alpha: 0.5),
                      fontFamily: AppStrings.nunitoFont,
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Example sentences
          if (word.sentences.isNotEmpty)
            _InfoBlock(
              label: 'Examples',
              accent: accent,
              child: Column(
                children: [
                  for (int i = 0; i < word.sentences.length; i++) ...[
                    if (i > 0) const SizedBox(height: 10),
                    _SentenceRow(
                      sentence: word.sentences[i],
                      accent: accent,
                      index: i,
                    ),
                  ],
                ],
              ),
            ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// ─── Info block ───────────────────────────────────────────────────────────────

class _InfoBlock extends StatelessWidget {
  const _InfoBlock({
    required this.label,
    required this.accent,
    required this.child,
  });

  final String label;
  final Color accent;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: accent,
              fontFamily: AppStrings.nunitoFont,
              fontWeight: FontWeight.w800,
              fontSize: 12,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

// ─── Sentence row ─────────────────────────────────────────────────────────────

class _SentenceRow extends StatelessWidget {
  const _SentenceRow({
    required this.sentence,
    required this.accent,
    required this.index,
  });

  final VocabSentence sentence;
  final Color accent;
  final int index;

  static const Color _ink = Color(0xFF101828);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 3),
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.10),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '${index + 1}',
              style: TextStyle(
                color: accent,
                fontFamily: AppStrings.nunitoFont,
                fontWeight: FontWeight.w800,
                fontSize: 11,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                sentence.sentence,
                style: const TextStyle(
                  color: _ink,
                  fontFamily: AppStrings.nunitoFont,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                sentence.translation,
                style: TextStyle(
                  color: _ink.withValues(alpha: 0.5),
                  fontFamily: AppStrings.nunitoFont,
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Bottom nav ───────────────────────────────────────────────────────────────

class _BottomNav extends StatelessWidget {
  const _BottomNav({
    required this.currentIndex,
    required this.total,
    required this.accent,
    required this.onPrev,
    required this.onNext,
    required this.onDone,
  });

  final int currentIndex;
  final int total;
  final Color accent;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final VoidCallback onDone;

  bool get _isFirst => currentIndex == 0;
  bool get _isLast => currentIndex == total - 1;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
        child: Row(
          children: [
            // Prev
            _NavButton(
              onTap: _isFirst ? null : onPrev,
              accent: accent,
              icon: Icons.arrow_back_ios_new_rounded,
              label: 'Prev',
              filled: false,
            ),
            const SizedBox(width: 12),
            // Next / Done
            Expanded(
              child: _isLast
                  ? _NavButton(
                      onTap: onDone,
                      accent: accent,
                      icon: Icons.check_rounded,
                      label: 'Done',
                      filled: true,
                      expand: true,
                    )
                  : _NavButton(
                      onTap: onNext,
                      accent: accent,
                      icon: Icons.arrow_forward_ios_rounded,
                      label: 'Next',
                      filled: true,
                      expand: true,
                      iconTrailing: true,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.onTap,
    required this.accent,
    required this.icon,
    required this.label,
    required this.filled,
    this.expand = false,
    this.iconTrailing = false,
  });

  final VoidCallback? onTap;
  final Color accent;
  final IconData icon;
  final String label;
  final bool filled;
  final bool expand;
  final bool iconTrailing;

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;
    final bg = filled
        ? (disabled ? Colors.grey.shade200 : accent)
        : Colors.transparent;
    final fg = filled
        ? Colors.white
        : (disabled ? Colors.grey.shade400 : accent);
    final border = filled ? null : Border.all(color: disabled ? Colors.grey.shade300 : accent, width: 1.5);

    Widget content = Row(
      mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (!iconTrailing) ...[
          Icon(icon, color: fg, size: 16),
          const SizedBox(width: 6),
        ],
        Text(
          label,
          style: TextStyle(
            color: fg,
            fontFamily: AppStrings.nunitoFont,
            fontWeight: FontWeight.w800,
            fontSize: 15,
          ),
        ),
        if (iconTrailing) ...[
          const SizedBox(width: 6),
          Icon(icon, color: fg, size: 16),
        ],
      ],
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: expand ? double.infinity : null,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
          border: border,
        ),
        child: content,
      ),
    );
  }
}
