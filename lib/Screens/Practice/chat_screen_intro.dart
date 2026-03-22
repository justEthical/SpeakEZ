import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:lottie/lottie.dart';
import 'package:speak_ez/Constants/app_assets.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Controllers/global_controller.dart';
import 'package:speak_ez/Models/scenario_model.dart';
import 'package:speak_ez/Screens/Practice/chat_screen.dart';

class ChatScreenIntro extends StatefulWidget {
  final ScenarioModel scenarioModel;
  const ChatScreenIntro({super.key, required this.scenarioModel});

  @override
  State<ChatScreenIntro> createState() => _ChatScreenIntroState();
}

class _ChatScreenIntroState extends State<ChatScreenIntro>
    with TickerProviderStateMixin {
  StreamSubscription? _whisperSub;

  late final AnimationController _staggerController;
  late final Animation<double> _imageOpacity;
  late final Animation<Offset> _imageSlide;
  late final Animation<double> _badgeOpacity;
  late final Animation<Offset> _badgeSlide;
  late final Animation<double> _titleOpacity;
  late final Animation<Offset> _titleSlide;
  late final Animation<double> _introOpacity;
  late final Animation<Offset> _introSlide;
  late final Animation<double> _loaderOpacity;
  late final Animation<Offset> _loaderSlide;

  @override
  void initState() {
    super.initState();

    // Animation setup
    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _imageOpacity = CurvedAnimation(
      parent: _staggerController,
      curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
    );
    _imageSlide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(_imageOpacity);

    _badgeOpacity = CurvedAnimation(
      parent: _staggerController,
      curve: const Interval(0.15, 0.55, curve: Curves.easeOut),
    );
    _badgeSlide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(_badgeOpacity);

    _titleOpacity = CurvedAnimation(
      parent: _staggerController,
      curve: const Interval(0.25, 0.65, curve: Curves.easeOut),
    );
    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(_titleOpacity);

    _introOpacity = CurvedAnimation(
      parent: _staggerController,
      curve: const Interval(0.35, 0.75, curve: Curves.easeOut),
    );
    _introSlide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(_introOpacity);

    _loaderOpacity = CurvedAnimation(
      parent: _staggerController,
      curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
    );
    _loaderSlide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(_loaderOpacity);

    _staggerController.forward();

    // Whisper initialization logic (unchanged)
    if (globalController.isWhisperInitialized.value) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _goToChat();
      });
    } else {
      if (!globalController.isDeepInfraTranscription.value) {
        globalController.startWhisperIsolate();
      }
      _whisperSub = globalController.isWhisperInitialized.listen((val) {
        if (val) _goToChat();
      });

      // If deep infra (no on-device), navigate immediately
      if (globalController.isDeepInfraTranscription.value) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _goToChat();
        });
      }
    }
  }

  void _goToChat() {
    _whisperSub?.cancel();
    Get.off(() => ChatScreen(scenarioModel: widget.scenarioModel));
  }

  @override
  void dispose() {
    _whisperSub?.cancel();
    _staggerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scenario = widget.scenarioModel;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Decorative background circles
            Positioned(
              top: -80,
              right: -50,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.primary
                      .withValues(alpha: isDark ? 0.08 : 0.15),
                ),
              ),
            ),
            Positioned(
              bottom: 60,
              left: -70,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.secondary
                      .withValues(alpha: isDark ? 0.06 : 0.10),
                ),
              ),
            ),
            Positioned(
              top: 280,
              right: -40,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.tertiary
                      .withValues(alpha: isDark ? 0.05 : 0.08),
                ),
              ),
            ),

            // Main content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),

                  // Scenario image with shadow and gradient overlay
                  FadeTransition(
                    opacity: _imageOpacity,
                    child: SlideTransition(
                      position: _imageSlide,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: theme.colorScheme.primary.withValues(
                                alpha: isDark ? 0.3 : 0.2,
                              ),
                              blurRadius: 24,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Stack(
                            children: [
                              Image.asset(
                                scenario.imagePath,
                                height: 120,
                                width: 120,
                                fit: BoxFit.cover,
                              ),
                              Positioned.fill(
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withValues(
                                          alpha: isDark ? 0.50 : 0.35,
                                        ),
                                      ],
                                      stops: const [0.5, 1.0],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Level badge with gradient
                  FadeTransition(
                    opacity: _badgeOpacity,
                    child: SlideTransition(
                      position: _badgeSlide,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            colors: [
                              theme.colorScheme.primary,
                              theme.colorScheme.primary
                                  .withValues(alpha: 0.7),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: theme.colorScheme.primary.withValues(
                                alpha: isDark ? 0.35 : 0.25,
                              ),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          scenario.level,
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: AppStrings.nunitoFont,
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Title
                  FadeTransition(
                    opacity: _titleOpacity,
                    child: SlideTransition(
                      position: _titleSlide,
                      child: Text(
                        scenario.title,
                        style: TextStyle(
                          fontFamily: AppStrings.poppinsFont,
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                          color: theme.colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Intro text
                  FadeTransition(
                    opacity: _introOpacity,
                    child: SlideTransition(
                      position: _introSlide,
                      child: Text(
                        scenario.description,
                        style: TextStyle(
                          fontFamily: AppStrings.nunitoFont,
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: theme.colorScheme.onSurfaceVariant,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Lottie loader
                  FadeTransition(
                    opacity: _loaderOpacity,
                    child: SlideTransition(
                      position: _loaderSlide,
                      child: Column(
                        children: [
                          SizedBox(
                            width: 80,
                            height: 80,
                            child: Lottie.asset(
                              AppAssets.chatting,
                              repeat: true,
                              decoder: globalController.customDecoder,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Getting ready...',
                            style: TextStyle(
                              fontFamily: AppStrings.nunitoFont,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
