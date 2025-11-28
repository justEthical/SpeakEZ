import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Controllers/global_controller.dart';
import 'package:speak_ez/Screens/HomeScreen/home_screen.dart';
import 'package:speak_ez/Screens/HomeScreen/streak_screen.dart';
import 'package:speak_ez/Screens/Practice/practice_speaking.dart';
import 'package:speak_ez/Screens/SettingsScreen/setting_screens.dart';
import 'package:speak_ez/Services/posthog_service.dart';
import 'package:speak_ez/Constants/posthog_events.dart';
import 'package:speak_ez/Utils/whisper_helper.dart';

class TabBarScreen extends StatefulWidget {
  final bool showStreakOrGemDialog;
  final int? gemEarned;
  final int? streak;
  const TabBarScreen({super.key,  this.showStreakOrGemDialog = false, this.gemEarned, this.streak});

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
    final isOnDeviceTranscriptionSupported = globalController.prefs?.getBool(AppStrings.isOnDeviceTranscriptionSupported);  
    Future.delayed(Duration.zero, () async {
      if (!await WhisperHelper.isModelZipAvailable() && isOnDeviceTranscriptionSupported == null) {
        WhisperHelper.runSilentDownload();
      }else if(isOnDeviceTranscriptionSupported == null){
        WhisperHelper.canModelRunOnDevice();
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // if(widget.showStreakOrGemDialog){

      // }
      Get.to(StreakScreen(gems: 100,));
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (a, _) {
        backButtonCount++;
        globalController.showSnackbarWithGetX("Exit", "Press again to exit");
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
          children: [HomeScreen(), PracticeSpeaking(), SettingScreens()],
        ),
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            onTap: (value) {
              final tabName = value == 0 ? 'progress' : 'practice';
              PostHogService.instance.capture(
                PostHogEvents.tabChanged,
                properties: {
                  'tab_name': tabName,
                  'tab_index': value,
                  'screen_name': 'tab_bar_screen',
                },
              );
              globalController.currentTabIndex.value = value;
              globalController.cutomTabBarController.animateToPage(
                value,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeIn,
              );
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.workspace_premium_outlined),
                label: "Progress",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat_bubble_outline),
                label: "Practice",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: "Profile",
              ),
            ],
            currentIndex: globalController.currentTabIndex.value,
          ),
        ),
      ),
    );
  }
}
