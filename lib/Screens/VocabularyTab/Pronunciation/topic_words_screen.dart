import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Controllers/vocabulary_tab_controller.dart';
import 'package:speak_ez/Models/pronunciation_word_model.dart';
import 'package:speak_ez/Services/pronunciation_scoring_service.dart';
import 'package:speak_ez/Utils/flutter_stt_helper.dart';
import 'package:speak_ez/Utils/tts_helper.dart';

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

class _TopicWordsScreenState extends State<TopicWordsScreen>
    with SingleTickerProviderStateMixin {
  static const Color _ink = Color(0xFF101828);
  static const Color _surface = Color(0xFFF7F8FC);

  final _vocabController = Get.find<VocabularyTabController>();
  final _pageController = PageController();
  final _speechService = SpeechService();
  final _scoringService = PronunciationScoringService();

  // Pulse animation for mic listening state
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  int _currentIndex = 0;
  bool _isListening = false;
  bool _isSpeaking = false;
  PronunciationScoreResult? _scoreResult;
  String _transcript = '';

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.18).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _vocabController.loadTopicWords(
        widget.levelCode,
        widget.categoryName,
        widget.topicName,
      );
      _autoSpeak();
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _pageController.dispose();
    ttsHelper.stop();
    if (_speechService.isListening) _speechService.stopListening();
    super.dispose();
  }

  // ── TTS ────────────────────────────────────────────────────────────────────

  void _autoSpeak() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _speak();
    });
  }

  Future<void> _speak() async {
    if (_isSpeaking) return;
    await ttsHelper.stop();
    setState(() => _isSpeaking = true);
    try {
      await ttsHelper.speakWordAndWait(_currentWord.word);
    } finally {
      if (mounted) setState(() => _isSpeaking = false);
    }
  }

  Future<void> _speakSlow() async {
    if (_isSpeaking) return;
    await ttsHelper.stop();
    setState(() => _isSpeaking = true);
    try {
      await ttsHelper.speakSlowAndWait(_currentWord.word);
    } finally {
      if (mounted) setState(() => _isSpeaking = false);
    }
  }

  // ── Mic ────────────────────────────────────────────────────────────────────

  Future<void> _toggleMic() async {
    if (_isListening) {
      _speechService.stopListening();
      setState(() => _isListening = false);
      return;
    }

    final status = await Permission.microphone.request();
    if (!status.isGranted) return;

    await ttsHelper.stop();
    setState(() {
      _scoreResult = null;
      _transcript = '';
      _isListening = true;
    });

    _speechService.startListening(
      (text) => setState(() => _transcript = text),
      (listening) {
        if (!listening && mounted) _onListeningDone();
      },
    );
  }

  void _onListeningDone() {
    setState(() => _isListening = false);
    if (_transcript.isEmpty) return;

    final result = _scoringService.evaluate(
      targetWord: _currentWord.word,
      transcript: _transcript,
    );
    setState(() => _scoreResult = result);

    // Auto-advance on pass if not on last word
    final words = _vocabController.currentTopicWords.value.words;
    if (result.isPass && _currentIndex < words.length - 1) {
      Future.delayed(const Duration(milliseconds: 1600), () {
        if (mounted) _goTo(_currentIndex + 1);
      });
    }
  }

  // ── Navigation ─────────────────────────────────────────────────────────────

  void _goTo(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  void _onPageChanged(int i) {
    setState(() {
      _currentIndex = i;
      _scoreResult = null;
      _transcript = '';
      _isListening = false;
      _isSpeaking = false;
    });
    ttsHelper.stop();
    if (_speechService.isListening) _speechService.stopListening();
    _autoSpeak();
  }

  VocabWord get _currentWord =>
      _vocabController.currentTopicWords.value.words[_currentIndex];

  // ── Build ──────────────────────────────────────────────────────────────────

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
        if (_vocabController.isLoadingTopicWords.value) {
          return Center(
            child: CircularProgressIndicator(color: widget.accent),
          );
        }

        final words = _vocabController.currentTopicWords.value.words;

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
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
              child: Row(
                children: [
                  Expanded(
                    child: TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOutCubic,
                      tween: Tween<double>(
                        begin: 0,
                        end: (_currentIndex + 1) / words.length,
                      ),
                      builder: (_, value, __) => ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: value,
                          backgroundColor:
                              widget.accent.withValues(alpha: 0.12),
                          color: widget.accent,
                          minHeight: 5,
                        ),
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
                physics: const NeverScrollableScrollPhysics(),
                itemCount: words.length,
                onPageChanged: _onPageChanged,
                itemBuilder: (context, i) => _WordCard(
                  word: words[i],
                  accent: widget.accent,
                  isSpeaking: _isSpeaking,
                  onSpeak: _speak,
                  onSpeakSlow: _speakSlow,
                ),
              ),
            ),

            // Result panel
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              child: _scoreResult != null
                  ? _ResultPanel(
                      result: _scoreResult!,
                      transcript: _transcript,
                      accent: widget.accent,
                      isLast:
                          _currentIndex == words.length - 1,
                      onTryAgain: () =>
                          setState(() => _scoreResult = null),
                    )
                  : const SizedBox.shrink(),
            ),

            // Action row (mic only)
            _ActionRow(
              accent: widget.accent,
              isListening: _isListening,
              pulseAnimation: _pulseAnimation,
              onMic: _toggleMic,
            ),

            // Bottom nav
            _BottomNav(
              currentIndex: _currentIndex,
              total: words.length,
              accent: widget.accent,
              canAdvance: _scoreResult != null && _scoreResult!.isPass,
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
  const _WordCard({
    required this.word,
    required this.accent,
    required this.isSpeaking,
    required this.onSpeak,
    required this.onSpeakSlow,
  });

  final VocabWord word;
  final Color accent;
  final bool isSpeaking;
  final VoidCallback onSpeak;
  final VoidCallback onSpeakSlow;

  static const Color _ink = Color(0xFF101828);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Word card
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
                // TODO: animation goes here
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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
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

                // Speak buttons
                const SizedBox(height: 16),
                Divider(height: 1, color: _ink.withValues(alpha: 0.06)),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _SpeakButton(
                        icon: Icons.volume_up_rounded,
                        label: 'Speak',
                        accent: accent,
                        disabled: isSpeaking,
                        onTap: onSpeak,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _SpeakButton(
                        icon: Icons.slow_motion_video_rounded,
                        label: 'Slow',
                        accent: accent,
                        disabled: isSpeaking,
                        onTap: onSpeakSlow,
                      ),
                    ),
                  ],
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

          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

// ─── Action row ───────────────────────────────────────────────────────────────

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.accent,
    required this.isListening,
    required this.pulseAnimation,
    required this.onMic,
  });

  final Color accent;
  final bool isListening;
  final Animation<double> pulseAnimation;
  final VoidCallback onMic;

  @override
  Widget build(BuildContext context) {
    final micButton = _ActionButton(
      icon: isListening ? Icons.stop_rounded : Icons.mic_rounded,
      label: isListening ? 'Stop' : 'Speak it',
      color: isListening ? Colors.red.shade500 : accent,
      filled: isListening,
      onTap: onMic,
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: isListening
          ? AnimatedBuilder(
              animation: pulseAnimation,
              builder: (_, child) =>
                  Transform.scale(scale: pulseAnimation.value, child: child),
              child: micButton,
            )
          : micButton,
    );
  }
}

// ─── Speak button (inside word card) ─────────────────────────────────────────

class _SpeakButton extends StatelessWidget {
  const _SpeakButton({
    required this.icon,
    required this.label,
    required this.accent,
    required this.disabled,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color accent;
  final bool disabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = disabled ? const Color(0xFFD1D5DB) : accent;
    return GestureDetector(
      onTap: disabled ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontFamily: AppStrings.nunitoFont,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.filled = false,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: filled ? color : color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: filled
              ? null
              : Border.all(color: color.withValues(alpha: 0.25), width: 1.2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: filled ? Colors.white : color, size: 22),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: filled ? Colors.white : color,
                fontFamily: AppStrings.nunitoFont,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Result panel ─────────────────────────────────────────────────────────────

class _ResultPanel extends StatelessWidget {
  const _ResultPanel({
    required this.result,
    required this.transcript,
    required this.accent,
    required this.isLast,
    required this.onTryAgain,
  });

  final PronunciationScoreResult result;
  final String transcript;
  final Color accent;
  final bool isLast;
  final VoidCallback onTryAgain;

  Color get _bandColor {
    if (result.score >= 90) return const Color(0xFF10B981);
    if (result.score >= 75) return const Color(0xFF3B82F6);
    if (result.score >= 60) return const Color(0xFFF59E0B);
    return const Color(0xFFEF4444);
  }

  IconData get _bandIcon {
    if (result.score >= 90) return Icons.star_rounded;
    if (result.score >= 75) return Icons.check_circle_rounded;
    if (result.score >= 60) return Icons.warning_amber_rounded;
    return Icons.replay_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final color = _bandColor;
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.25), width: 1.2),
      ),
      child: Row(
        children: [
          // Score circle
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(_bandIcon, color: color, size: 18),
                  Text(
                    '${result.score.round()}',
                    style: TextStyle(
                      color: color,
                      fontFamily: AppStrings.nunitoFont,
                      fontWeight: FontWeight.w900,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Text info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  result.band,
                  style: TextStyle(
                    color: color,
                    fontFamily: AppStrings.nunitoFont,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'You said: "$transcript"',
                  style: TextStyle(
                    color: const Color(0xFF101828).withValues(alpha: 0.6),
                    fontFamily: AppStrings.nunitoFont,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (result.isPass && !isLast)
                  Text(
                    'Moving to next word…',
                    style: TextStyle(
                      color: color,
                      fontFamily: AppStrings.nunitoFont,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
          // Try again button (only on fail)
          if (!result.isPass)
            GestureDetector(
              onTap: onTryAgain,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Retry',
                  style: TextStyle(
                    color: color,
                    fontFamily: AppStrings.nunitoFont,
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
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
    required this.canAdvance,
    required this.onPrev,
    required this.onNext,
    required this.onDone,
  });

  final int currentIndex;
  final int total;
  final Color accent;
  final bool canAdvance;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final VoidCallback onDone;

  bool get _isFirst => currentIndex == 0;
  bool get _isLast => currentIndex == total - 1;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
        child: Row(
          children: [
            _NavButton(
              onTap: _isFirst ? null : onPrev,
              accent: accent,
              icon: Icons.arrow_back_ios_new_rounded,
              label: 'Prev',
              filled: false,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _isLast
                  ? _NavButton(
                      onTap: canAdvance ? onDone : null,
                      accent: accent,
                      icon: Icons.check_rounded,
                      label: 'Done',
                      filled: true,
                      expand: true,
                    )
                  : _NavButton(
                      onTap: canAdvance ? onNext : null,
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
    final bg =
        filled ? (disabled ? Colors.grey.shade200 : accent) : Colors.transparent;
    final fg = filled ? Colors.white : (disabled ? Colors.grey.shade400 : accent);
    final border = filled
        ? null
        : Border.all(
            color: disabled ? Colors.grey.shade300 : accent,
            width: 1.5,
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
        child: Row(
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
        ),
      ),
    );
  }
}
