import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:speak_ez/Constants/app_assets.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Controllers/global_controller.dart';
import 'package:speak_ez/Controllers/practice_controller.dart';
import 'package:speak_ez/Models/evaluation_result.dart';
import 'package:speak_ez/Screens/Practice/ResultScreen/detailed_result.dart';
import 'package:speak_ez/Screens/custom_review_screen.dart';
import 'package:speak_ez/Utils/custom_loader.dart';

import 'Widgets/result_title.dart';
import 'Widgets/score_bar.dart';

class PracticeResultSreen extends StatefulWidget {
  final FeedbackResult result;
  const PracticeResultSreen({super.key, required this.result});

  @override
  State<PracticeResultSreen> createState() => _PracticeResultSreenState();
}

class _PracticeResultSreenState extends State<PracticeResultSreen>
    with TickerProviderStateMixin {
  final GlobalKey globalKey = GlobalKey();

  // Stagger animation controller (1200ms for entry animations)
  late AnimationController _staggerController;

  // Entry animations
  late Animation<double> _appBarAnimation;
  late Animation<double> _scoreCardAnimation;
  late Animation<double> _motivationAnimation;
  late List<Animation<double>> _tileAnimations;

  // Button scale animations
  late AnimationController _doneButtonController;
  late Animation<double> _doneButtonScale;
  late AnimationController _feedbackButtonController;
  late Animation<double> _feedbackButtonScale;

  // Celebration state
  bool _showCelebration = false;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startAnimations();
  }

  void _initAnimations() {
    // Stagger controller for entry animations
    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // App Bar Title: Fade + slide down (0-180ms)
    _appBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _staggerController,
        curve: const Interval(0.0, 0.15, curve: Curves.easeOut),
      ),
    );

    // Score Card: Fade + slide up (120-420ms)
    _scoreCardAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _staggerController,
        curve: const Interval(0.1, 0.35, curve: Curves.easeOut),
      ),
    );

    // Motivation Card: Fade + slide up (300-540ms)
    _motivationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _staggerController,
        curve: const Interval(0.25, 0.45, curve: Curves.easeOut),
      ),
    );

    // Result Tiles: Stagger fade + slide (420ms onwards, 96ms apart)
    // 6 tiles, each starting 0.08 (96ms) apart
    _tileAnimations = List.generate(6, (index) {
      final startInterval = 0.35 + (index * 0.08);
      final endInterval = (startInterval + 0.15).clamp(0.0, 1.0);
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _staggerController,
          curve: Interval(startInterval, endInterval, curve: Curves.easeOut),
        ),
      );
    });

    // Button scale controllers
    _doneButtonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _doneButtonScale = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _doneButtonController, curve: Curves.easeInOut),
    );

    _feedbackButtonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _feedbackButtonScale = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
          parent: _feedbackButtonController, curve: Curves.easeInOut),
    );

    // Trigger celebration after entry animations complete for high scores
    _staggerController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        final c = Get.find<PracticeController>();
        final score = c.getOverAllScore(widget.result);
        if (score > 70 && mounted) {
          setState(() {
            _showCelebration = true;
          });
        }
      }
    });
  }

  void _startAnimations() {
    // Start stagger animations
    _staggerController.forward();
  }

  @override
  void dispose() {
    _staggerController.dispose();
    _doneButtonController.dispose();
    _feedbackButtonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.find<PracticeController>();
    final theme = Theme.of(context);
    c.updatePracticeProgress();
    c.showInterstitialAd();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        title: AnimatedBuilder(
          animation: _appBarAnimation,
          builder: (context, child) {
            return Opacity(
              opacity: _appBarAnimation.value,
              child: Transform.translate(
                offset: Offset(0, -10 * (1 - _appBarAnimation.value)),
                child: Text(
                  AppStrings.score.tr,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
            );
          },
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.share_outlined,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            onPressed: () async {
              CustomLoader.showLoader();
              await c.captureAndShare(globalKey);
              CustomLoader.hideLoader();
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              RepaintBoundary(
                key: globalKey,
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  color: theme.scaffoldBackgroundColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildScoreCard(context, c, theme),
                      const SizedBox(height: 24),
                      _buildMotivationCard(context, theme),
                      const SizedBox(height: 24),
                      _buildFeedbackSection(c, context),
                    ],
                  ),
                ),
              ),
              _buildDoneButton(context, theme),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreCard(
    BuildContext context,
    PracticeController c,
    ThemeData theme,
  ) {
    final score = c.getOverAllScore(widget.result);

    return AnimatedBuilder(
      animation: _scoreCardAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _scoreCardAnimation.value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - _scoreCardAnimation.value)),
            child: child,
          ),
        );
      },
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  theme.primaryColor
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color:
                      Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  c.formatDateToLongString(DateTime.now()),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: AppStrings.nunitoFont,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "${AppStrings.score.tr}: $score/100",
                  style: TextStyle(
                    fontSize: 36,
                    fontFamily: AppStrings.nunitoFont,
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 12),
                ScoreBar(score: score),
              ],
            ),
          ),
          // Celebration overlay
          if (_showCelebration)
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: IgnorePointer(
                  child: Stack(
                    children: [
                      // Confetti
                      Positioned.fill(
                        child: Lottie.asset(
                          AppAssets.confetti,
                          decoder: globalController.customDecoder,
                          repeat: false,
                          fit: BoxFit.cover,
                        ),
                      ),
                      // Success animation
                      // Center(
                      //   child: SizedBox(
                      //     width: 120,
                      //     height: 120,
                      //     child: Lottie.asset(
                      //       AppAssets.resultSuccess,
                      //       decoder: globalController.customDecoder,
                      //       repeat: false,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMotivationCard(BuildContext context, ThemeData theme) {
    return AnimatedBuilder(
      animation: _motivationAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _motivationAnimation.value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - _motivationAnimation.value)),
            child: child,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          ),
        ),
        child: Text(
          widget.result.motivation,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: AppStrings.nunitoFont,
            color: Theme.of(context).textTheme.bodyMedium?.color,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }

  Widget _buildFeedbackSection(PracticeController c, context) {
    final [scoreMap, feedbackList] = c.getAverageScoreAndFeedback();
    final fluencyScore = scoreMap['fluency'] as double;
    final grammarScore = scoreMap['grammar'] as double;
    final vocabularyScore = scoreMap['vocabulary'] as double;
    final pronunciationScore = scoreMap['pronunciation'] as double;

    return Column(
      children: [
        ResultTile(
          onTap: () {},
          icon: AppAssets.fluency,
          heading:
              '${AppStrings.fluency.tr} (${fluencyScore.toStringAsFixed(1)}/10)',
          content: widget.result.fluency,
          padding: 10,
          score: fluencyScore,
          entryAnimation: _tileAnimations[0],
        ),
        ResultTile(
          onTap: () {},
          icon: AppAssets.grammar,
          heading:
              '${AppStrings.grammar.tr} (${grammarScore.toStringAsFixed(1)}/10)',
          content: widget.result.grammar,
          score: grammarScore,
          entryAnimation: _tileAnimations[1],
        ),
        ResultTile(
          onTap: () {},
          icon: AppAssets.vocabulary,
          heading:
              '${AppStrings.vocabulary.tr} (${vocabularyScore.toStringAsFixed(1)}/10)',
          content: widget.result.vocabulary,
          score: vocabularyScore,
          entryAnimation: _tileAnimations[2],
        ),
        ResultTile(
          onTap: () {},
          icon: AppAssets.prononciation,
          heading:
              '${AppStrings.pronunciationLabel.tr} (${pronunciationScore.toStringAsFixed(1)}/10)',
          content: widget.result.pronunciation,
          score: pronunciationScore,
          entryAnimation: _tileAnimations[3],
        ),
        ResultTile(
          onTap: () {},
          icon: AppAssets.totalSpeakingTime,
          heading: AppStrings.totalSpeakingTime.tr,
          content:
              '${c.formatDuration(c.totalSpeakingTime)} ${AppStrings.minutes.tr}',
          entryAnimation: _tileAnimations[4],
          showBorder: true,
        ),
        ResultTile(
          onTap: () {},
          icon: AppAssets.tip,
          heading: AppStrings.suggestion.tr,
          content: widget.result.suggestion,
          entryAnimation: _tileAnimations[5],
          showBorder: true,
        ),
        // Detailed Feedback Button with animation
        AnimatedBuilder(
          animation: _tileAnimations[5],
          builder: (context, child) {
            return Opacity(
              opacity: _tileAnimations[5].value,
              child: Transform.translate(
                offset: Offset(0, 20 * (1 - _tileAnimations[5].value)),
                child: child,
              ),
            );
          },
          child: AnimatedBuilder(
            animation: _feedbackButtonScale,
            builder: (context, child) {
              return Transform.scale(
                scale: _feedbackButtonScale.value,
                child: child,
              );
            },
            child: GestureDetector(
              onTapDown: (_) {
                _feedbackButtonController.forward();
                HapticFeedback.lightImpact();
              },
              onTapUp: (_) {
                _feedbackButtonController.reverse();
              },
              onTapCancel: () {
                _feedbackButtonController.reverse();
              },
              onTap: () {
                HapticFeedback.mediumImpact();
                Get.to(() => const DetailedResult());
              },
              child: Container(
                height: 50,
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                      Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 1.5,
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppStrings.detailedFeedback.tr,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Theme.of(context).colorScheme.primary,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDoneButton(BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: AnimatedBuilder(
        animation: _doneButtonScale,
        builder: (context, child) {
          return Transform.scale(
            scale: _doneButtonScale.value,
            child: child,
          );
        },
        child: GestureDetector(
          onTapDown: (_) {
            _doneButtonController.forward();
            HapticFeedback.lightImpact();
          },
          onTapUp: (_) {
            _doneButtonController.reverse();
          },
          onTapCancel: () {
            _doneButtonController.reverse();
          },
          onTap: () {
            HapticFeedback.mediumImpact();
            globalController.userProfile.refresh();
            final completedSessions =
                globalController.prefs?.getInt(
                  AppStrings.completedPracticeSessions.tr,
                ) ??
                0;
            final isItTimeToShowCustomReview = completedSessions % 5;
            if ((isItTimeToShowCustomReview == 1) &&
                !globalController
                    .userProfile.value.isShownCustomReviewDialogOnce) {
              showReviewPromptBottomSheet(
                context,
                onClose: () {
                  Get.back();
                },
              );
            } else {
              Get.back();
            }
          },
          child: Container(
            height: 55,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.onSurface,
                  Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.85),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                AppStrings.done.tr,
                style: TextStyle(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  fontWeight: FontWeight.w800,
                  fontFamily: AppStrings.nunitoFont,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
