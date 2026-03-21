import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Controllers/global_controller.dart';
import 'package:speak_ez/Screens/HomeScreen/home_screen.dart';
import 'package:speak_ez/Screens/HomeScreen/streak_screen.dart';
import 'package:speak_ez/Screens/Practice/practice_speaking.dart';
import 'package:speak_ez/Screens/SettingsScreen/setting_screens.dart';
import 'package:speak_ez/Screens/VocabularyTab/vocabulary_builder_screen.dart';
import 'package:speak_ez/Services/admob_service.dart';
import 'package:speak_ez/Services/posthog_service.dart';
import 'package:speak_ez/Constants/posthog_events.dart';
import 'package:speak_ez/Utils/canary_helper.dart';

class TabBarScreen extends StatefulWidget {
  final int? gemEarned;
  const TabBarScreen({super.key, this.gemEarned});

  @override
  State<TabBarScreen> createState() => _TabBarScreenState();
}

class _TabBarScreenState extends State<TabBarScreen> {
  var backButtonCount = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    globalController.askNotificationPermission();
    globalController.setIsDeepInfraTranscription();
    PostHogService.instance.setUserIdentity();
    final isOnDeviceTranscriptionSupported = globalController.prefs?.getBool(
      AppStrings.isOnDeviceTranscriptionSupported,
    );
    Future.delayed(Duration.zero, () async {
      if (!await CanaryHelper.isModelZipAvailable() &&
          isOnDeviceTranscriptionSupported == null) {
        CanaryHelper.runSilentDownload();
      } else if (isOnDeviceTranscriptionSupported == null) {
        CanaryHelper.canModelRunOnDevice();
      }
    });
    // check if gems are lower than 100 then only load rewarded ad
    // for free talk session
    if (globalController.userProfile.value.gems < 100) {
      GoogleMobileAdsService.instance.loadRewarded(
        adUnitId: AppStrings.rewardedAdUnitId,
      );
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.gemEarned != null) {
        Get.to(StreakScreen(gems: widget.gemEarned));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (a, _) {
        backButtonCount++;
        globalController.showSnackbarWithGetX(
          AppStrings.exit.tr,
          AppStrings.pressAgainToExit.tr,
        );
        if (backButtonCount == 2) {
          SystemNavigator.pop();
        }
        Future.delayed(Duration(seconds: 2), () {
          backButtonCount = 0;
        });
      },
      child: Scaffold(
        body: PageView(
          controller: globalController.cutomTabBarController,
          physics: NeverScrollableScrollPhysics(),
          children: [
            HomeScreen(),
            PracticeSpeaking(),
            VocabularyBuilderScreen(),
            SettingScreens(),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            height: 60,
            margin: EdgeInsets.only(left: 15, right: 15, bottom: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border.all(color: Colors.grey, width: 0.4),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.3),
                  spreadRadius: 2,
                  blurRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Obx(
              () => SalomonBottomBar(
                currentIndex: globalController.currentTabIndex.value,
                onTap: (value) {
                  final tabNames = [
                    'progress',
                    'practice',
                    'vocabulary',
                    'settings',
                  ];
                  PostHogService.instance.capture(
                    PostHogEvents.tabChanged,
                    properties: {
                      'tab_name': tabNames[value],
                      'tab_index': value,
                      'screen_name': 'tab_bar_screen',
                    },
                  );
                  globalController.currentTabIndex.value = value;
                  globalController.cutomTabBarController.jumpToPage(value);
                },
                items: [
                  SalomonBottomBarItem(
                    icon: Icon(Icons.workspace_premium_outlined),
                    title: Text(AppStrings.progress.tr),
                    selectedColor: Colors.deepPurple,
                  ),
                  SalomonBottomBarItem(
                    icon: Icon(Icons.chat_bubble_outline),
                    title: Text(AppStrings.practice.tr),
                    selectedColor: Colors.blue,
                  ),
                  // SalomonBottomBarItem(
                  //   icon: Icon(Icons.record_voice_over_rounded),
                  //   title: Text(AppStrings.freeTalk.tr),
                  //   selectedColor: Colors.orange,
                  // ),
                  SalomonBottomBarItem(
                    icon: Icon(Icons.menu_book_rounded),
                    title: Text(AppStrings.vocabulary.tr),
                    selectedColor: Colors.orange,
                  ),
                  SalomonBottomBarItem(
                    icon: Icon(Icons.settings),
                    title: Text(AppStrings.profile.tr),
                    selectedColor: Colors.teal,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
