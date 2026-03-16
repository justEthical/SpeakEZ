import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:speak_ez/Controllers/global_controller.dart';
import 'package:speak_ez/Models/scenario_model.dart';
import 'package:speak_ez/Screens/Practice/chat_screen.dart';

class ChatScreenIntro extends StatefulWidget {
  final ScenarioModel scenarioModel;
  const ChatScreenIntro({super.key, required this.scenarioModel});

  @override
  State<ChatScreenIntro> createState() => _ChatScreenIntroState();
}

class _ChatScreenIntroState extends State<ChatScreenIntro> {
  StreamSubscription? _whisperSub;

  @override
  void initState() {
    super.initState();
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scenario = widget.scenarioModel;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              // Scenario image
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  scenario.imagePath,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 28),
              // Level badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  scenario.level,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Title
              Text(
                scenario.title,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              // Intro text
              Text(
                scenario.intro,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              // Loading indicator
              Column(
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    'Getting ready...',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
