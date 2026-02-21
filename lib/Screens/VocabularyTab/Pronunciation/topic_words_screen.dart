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

  // Lesson result tracking
  bool _wordCompleted = false;
  int _skippedCount = 0;
  int _perfectCount = 0;
  int _incorrectCount = 0;
  bool _showSummary = false;

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
    final cleaned = _cleanTranscript(_transcript);
    if (cleaned.isEmpty) return;

    final result = _scoringService.evaluate(
      targetWord: _currentWord.word,
      transcript: cleaned,
    );
    setState(() => _scoreResult = result);

    if (result.isPass && !_wordCompleted) {
      setState(() {
        _wordCompleted = true;
        if (result.score >= 90) {
          _perfectCount++;
        } else {
          _incorrectCount++;
        }
      });
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) _showNextSheet();
      });
    }
  }

  // Removes noise tags like [MUSIC] and non-alphabetic chars, matching lesson logic
  String _cleanTranscript(String text) {
    text = text.replaceAll(RegExp(r'\[.*?\]'), '');
    text = text.replaceAll(RegExp(r'[^a-zA-Z\s]'), ' ');
    return text.replaceAll(RegExp(r'\s+'), ' ').trim();
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
      _wordCompleted = false;
    });
    ttsHelper.stop();
    if (_speechService.isListening) _speechService.stopListening();
    _autoSpeak();
  }

  void _skipWord() {
    if (_wordCompleted) return;
    final words = _vocabController.currentTopicWords.value.words;
    setState(() {
      _skippedCount++;
      _wordCompleted = true;
    });
    if (_currentIndex < words.length - 1) {
      _goTo(_currentIndex + 1);
    } else {
      setState(() => _showSummary = true);
    }
  }

  void _resetLesson() {
    ttsHelper.stop();
    if (_speechService.isListening) _speechService.stopListening();
    setState(() {
      _currentIndex = 0;
      _skippedCount = 0;
      _perfectCount = 0;
      _incorrectCount = 0;
      _showSummary = false;
      _scoreResult = null;
      _transcript = '';
      _isListening = false;
      _isSpeaking = false;
      _wordCompleted = false;
    });
    // PageView is re-attached on the next frame after _showSummary = false
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _pageController.jumpToPage(0);
        _autoSpeak();
      }
    });
  }

  void _showNextSheet() {
    final words = _vocabController.currentTopicWords.value.words;
    final isLast = _currentIndex == words.length - 1;
    final score = _scoreResult?.score.round() ?? 0;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sheetBg = Theme.of(context).colorScheme.onSecondary;

    showModalBottomSheet(
      context: context,
      backgroundColor: sheetBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.15)
                      : const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              // Score circle
              Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  color: Color(0xFFD1FAE5),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check_rounded,
                          color: Color(0xFF10B981), size: 28),
                      Text(
                        '$score',
                        style: const TextStyle(
                          color: Color(0xFF10B981),
                          fontFamily: AppStrings.nunitoFont,
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                score >= 90
                    ? AppStrings.vocabExcellent.tr
                    : AppStrings.vocabGoodJob.tr,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontFamily: AppStrings.nunitoFont,
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${AppStrings.vocabPronunciationScore.tr}: $score / 100',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.45),
                  fontFamily: AppStrings.nunitoFont,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 24),
              _BottomSheetOption(
                label: isLast
                    ? AppStrings.vocabSeeResults.tr
                    : AppStrings.vocabNextWord.tr,
                icon: isLast
                    ? Icons.bar_chart_rounded
                    : Icons.arrow_forward_ios_rounded,
                color: widget.accent,
                filled: true,
                onTap: () {
                  Get.back();
                  if (isLast) {
                    setState(() => _showSummary = true);
                  } else {
                    _goTo(_currentIndex + 1);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryView(int totalWords) {
    final ink = Theme.of(context).colorScheme.onSurface;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            const Spacer(flex: 2),

            // Trophy icon
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [widget.accent, widget.accent.withValues(alpha: 0.7)],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: widget.accent.withValues(alpha: 0.35),
                    blurRadius: 28,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(Icons.emoji_events_rounded,
                  color: Colors.white, size: 50),
            ),

            const SizedBox(height: 22),

            Text(
              AppStrings.vocabLessonComplete.tr,
              style: TextStyle(
                color: ink,
                fontFamily: AppStrings.nunitoFont,
                fontWeight: FontWeight.w900,
                fontSize: 26,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              widget.topicName,
              style: TextStyle(
                color: ink.withValues(alpha: 0.45),
                fontFamily: AppStrings.nunitoFont,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$totalWords ${AppStrings.vocabWordsCompleted.tr}',
              style: TextStyle(
                color: ink.withValues(alpha: 0.3),
                fontFamily: AppStrings.nunitoFont,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 32),

            // Stat cards
            Row(
              children: [
                _StatCard(
                  icon: Icons.star_rounded,
                  color: const Color(0xFF10B981),
                  value: _perfectCount,
                  label: AppStrings.vocabPerfect.tr,
                ),
                const SizedBox(width: 12),
                _StatCard(
                  icon: Icons.close_rounded,
                  color: const Color(0xFFEF4444),
                  value: _incorrectCount,
                  label: AppStrings.vocabIncorrect.tr,
                ),
                const SizedBox(width: 12),
                _StatCard(
                  icon: Icons.skip_next_rounded,
                  color: const Color(0xFF9CA3AF),
                  value: _skippedCount,
                  label: AppStrings.vocabSkipped.tr,
                ),
              ],
            ),

            const Spacer(flex: 3),

            // Try Again
            _BottomSheetOption(
              label: AppStrings.vocabTryAgain.tr,
              icon: Icons.replay_rounded,
              color: widget.accent,
              filled: true,
              onTap: _resetLesson,
            ),
            const SizedBox(height: 12),

            // Exit
            _BottomSheetOption(
              label: AppStrings.vocabExitLesson.tr,
              icon: Icons.exit_to_app_rounded,
              color: const Color(0xFF6B7280),
              onTap: () => Get.back(),
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  VocabWord get _currentWord =>
      _vocabController.currentTopicWords.value.words[_currentIndex];

  // ── Build ──────────────────────────────────────────────────────────────────

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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.topicName,
              style: TextStyle(
                color: ink,
                fontFamily: AppStrings.nunitoFont,
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
            Text(
              widget.levelCode,
              style: TextStyle(
                color: ink.withValues(alpha: 0.45),
                fontFamily: AppStrings.nunitoFont,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: _showSummary
            ? const []
            : [
                TextButton(
                  onPressed: _skipWord,
                  child: Text(
                    AppStrings.vocabSkip.tr,
                    style: TextStyle(
                      color: ink.withValues(alpha: 0.45),
                      fontFamily: AppStrings.nunitoFont,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
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
              AppStrings.vocabNoWordsFound.tr,
              style: TextStyle(
                color: ink.withValues(alpha: 0.5),
                fontFamily: AppStrings.nunitoFont,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        }

        if (_showSummary) {
          return _buildSummaryView(words.length);
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

            // Fail message (only shown when answer is wrong)
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              child: _scoreResult != null && !_scoreResult!.isPass
                  ? _ResultPanel(
                      transcript: _transcript,
                      onTryAgain: () =>
                          setState(() => _scoreResult = null),
                    )
                  : const SizedBox.shrink(),
            ),

            // Action row (mic)
            _ActionRow(
              accent: widget.accent,
              isListening: _isListening,
              pulseAnimation: _pulseAnimation,
              onMic: _toggleMic,
            ),

            const SizedBox(height: 8),
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = Theme.of(context).colorScheme.onSecondary;
    final ink = Theme.of(context).colorScheme.onSurface;

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
              color: cardBg,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
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
                    color: ink.withValues(alpha: 0.4),
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
                Divider(height: 1, color: ink.withValues(alpha: 0.06)),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _SpeakButton(
                        icon: Icons.volume_up_rounded,
                        label: AppStrings.vocabSpeak.tr,
                        accent: accent,
                        disabled: isSpeaking,
                        onTap: onSpeak,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _SpeakButton(
                        icon: Icons.slow_motion_video_rounded,
                        label: AppStrings.vocabSlow.tr,
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
            label: AppStrings.vocabDefinition.tr,
            accent: accent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  word.definition,
                  style: TextStyle(
                    color: ink,
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
                      color: ink.withValues(alpha: 0.5),
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
              label: AppStrings.vocabExamples.tr,
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
      child: Center(
        child: isListening ? _buildListening(context) : _buildIdle(),
      ),
    );
  }

  Widget _buildIdle() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Circular mic button
        GestureDetector(
          onTap: onMic,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [accent, accent.withValues(alpha: 0.8)],
              ),
              borderRadius: BorderRadius.circular(100),
              boxShadow: [
                BoxShadow(
                  color: accent.withValues(alpha: 0.35),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(Icons.mic_rounded, color: Colors.white, size: 36),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          AppStrings.vocabTapToSpeak.tr,
          style: TextStyle(
            color: accent,
            fontFamily: AppStrings.nunitoFont,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildListening(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // "Tap to stop" hint
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.touch_app_rounded, size: 16, color: accent),
              const SizedBox(width: 6),
              Text(
                AppStrings.tapToStop.tr,
                style: TextStyle(
                  color: accent,
                  fontFamily: AppStrings.nunitoFont,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Pulsing red stop button
        AnimatedBuilder(
          animation: pulseAnimation,
          builder: (_, child) =>
              Transform.scale(scale: pulseAnimation.value, child: child),
          child: GestureDetector(
            onTap: onMic,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.red.shade400, Colors.red.shade600],
                ),
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withValues(alpha: 0.4),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Center(
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // "Listening" status badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.red.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Text(
                AppStrings.vocabListening.tr,
                style: TextStyle(
                  color: Colors.red.shade700,
                  fontFamily: AppStrings.nunitoFont,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
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

// ─── Result panel (fail state only) ──────────────────────────────────────────

class _ResultPanel extends StatelessWidget {
  const _ResultPanel({
    required this.transcript,
    required this.onTryAgain,
  });

  final String transcript;
  final VoidCallback onTryAgain;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7ED),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFF97316).withValues(alpha: 0.30),
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFF97316).withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(Icons.replay_rounded,
                  color: Color(0xFFEA580C), size: 22),
            ),
          ),
          const SizedBox(width: 12),
          // Message
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.vocabNotQuiteRight.tr,
                  style: const TextStyle(
                    color: Color(0xFF9A3412),
                    fontFamily: AppStrings.nunitoFont,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                if (transcript.isNotEmpty)
                  Text(
                    '${AppStrings.vocabYouSaid.tr} "$transcript"',
                    style: const TextStyle(
                      color: Color(0xFFC2410C),
                      fontFamily: AppStrings.nunitoFont,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                const SizedBox(height: 2),
                Text(
                  AppStrings.vocabGiveItAnotherTry.tr,
                  style: const TextStyle(
                    color: Color(0xFFC2410C),
                    fontFamily: AppStrings.nunitoFont,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          // Retry button
          GestureDetector(
            onTap: onTryAgain,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF97316).withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'retry'.tr,
                style: const TextStyle(
                  color: Color(0xFF9A3412),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = Theme.of(context).colorScheme.onSecondary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
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

// ─── Stat card (summary screen) ───────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final Color color;
  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = Theme.of(context).colorScheme.onSecondary;
    final labelColor = Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.45);

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 10),
            Text(
              '$value',
              style: TextStyle(
                color: color,
                fontFamily: AppStrings.nunitoFont,
                fontWeight: FontWeight.w900,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: labelColor,
                fontFamily: AppStrings.nunitoFont,
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Bottom sheet option ──────────────────────────────────────────────────────

class _BottomSheetOption extends StatelessWidget {
  const _BottomSheetOption({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
    this.filled = false,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;
    final effectiveColor = disabled ? const Color(0xFFD1D5DB) : color;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: filled
              ? effectiveColor
              : effectiveColor.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: filled
              ? null
              : Border.all(
                  color: effectiveColor.withValues(alpha: 0.20), width: 1),
        ),
        child: Row(
          children: [
            Icon(icon,
                color: filled ? Colors.white : effectiveColor, size: 20),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: filled ? Colors.white : effectiveColor,
                fontFamily: AppStrings.nunitoFont,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
          ],
        ),
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

  @override
  Widget build(BuildContext context) {
    final ink = Theme.of(context).colorScheme.onSurface;

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
                style: TextStyle(
                  color: ink,
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
                  color: ink.withValues(alpha: 0.5),
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
