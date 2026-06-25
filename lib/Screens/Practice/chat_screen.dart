import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Controllers/global_controller.dart';
import 'package:speak_ez/Controllers/practice_controller.dart';
import 'package:speak_ez/Models/scenario_model.dart';
import 'package:speak_ez/Screens/Practice/ResultScreen/practice_result_screen.dart';
import 'package:speak_ez/Screens/Practice/Widgets/chat_bubble.dart';
import 'package:speak_ez/Screens/Practice/Widgets/chat_screen_bottom_bar.dart';
import 'package:speak_ez/Services/admob_service.dart';
import 'package:speak_ez/Utils/tts_helper.dart';
import 'package:speak_ez/Services/posthog_service.dart';
import 'package:speak_ez/Constants/posthog_events.dart';

import 'Widgets/progress_bar.dart';

class ChatScreen extends StatefulWidget {
  final ScenarioModel scenarioModel;
  const ChatScreen({super.key, required this.scenarioModel});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with SingleTickerProviderStateMixin {
  final c = Get.find<PracticeController>();

  late AnimationController _appBarController;
  late Animation<double> _titleAnimation;

  @override
  void initState() {
    super.initState();

    _appBarController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _titleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _appBarController,
        curve: Curves.easeOut,
      ),
    );

    _appBarController.forward();

    PostHogService.instance.captureScreenView(
      'practice_chat_screen',
      properties: {
        'scenario_title': widget.scenarioModel.title,
        'scenario_description': widget.scenarioModel.description,
      },
    );
    PostHogService.instance.capture(
      PostHogEvents.practiceStarted,
      properties: {'scenario_title': widget.scenarioModel.title},
    );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      c.currentScenarioModel = widget.scenarioModel;
      c.currentConversationSummary = '';
      c.aiResponseList.clear();
      c.addInitialMessage();
    });
    GoogleMobileAdsService.instance.loadInterstitial(
      adUnitId: AppStrings.interstitialAdUnitId,
    );
    globalController.userProfile.value.gems -= 100;
    globalController.updateProfile();
  }

  @override
  void dispose() {
    _appBarController.dispose();
    super.dispose();
    PostHogService.instance.capture(
      PostHogEvents.practiceExited,
      properties: {
        'scenario_title': widget.scenarioModel.title,
        'messages_count': c.currentUserSessionMessage.value,
      },
    );
    if (globalController.isWhisperInitialized.value &&
        !c.sessionUsesDeepInfra) {
      globalController.whisperSendPort?.send('stop');
      globalController.isWhisperInitialized.value = false;
    }
    c.currentUserSessionMessage.value = 0;
    c.isChatResultReady.value = false;
    ttsHelper.stop();
    debugPrint("dissposed");
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: c.isBottomSheetOpen,
      onPopInvokedWithResult: (a, _) {
        if (!c.isBottomSheetOpen) {
          c.isBottomSheetOpen = true;
          c.showExitBottomSheet(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          centerTitle: true,
          title: FadeTransition(
            opacity: _titleAnimation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, -0.5),
                end: Offset.zero,
              ).animate(_titleAnimation),
              child: Text(
                widget.scenarioModel.title,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontFamily: AppStrings.nunitoFont,
                  fontSize: 18,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
            ),
          ),
          leading: FadeTransition(
            opacity: _titleAnimation,
            child: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 18,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              onPressed: () {
                HapticFeedback.lightImpact();
                c.isBottomSheetOpen = true;
                c.showExitBottomSheet(context);
              },
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              ProgressBar(),
              const SizedBox(height: 20),
              Expanded(
                child: Obx(
                  () => ListView.builder(
                    controller: c.chatScrollController,
                    itemCount: c.currentChats.length,
                    itemBuilder: (ctx, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: ChatBubble(chatModel: c.currentChats[index]),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SafeArea(
                child: Obx(
                  () =>
                      c.isChatResultReady.value
                          ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ElevatedButton(
                              onPressed: () {
                                PostHogService.instance.capture(
                                  PostHogEvents.practiceResultViewed,
                                  properties: {
                                    'scenario_title': widget.scenarioModel.title,
                                    'messages_count':
                                        c.currentUserSessionMessage.value,
                                  },
                                );
                
                                Get.off(
                                  PracticeResultSreen(result: c.resultModel!),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                "View Results",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                            ),
                          )
                          : ChatScreenBottomBar(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
