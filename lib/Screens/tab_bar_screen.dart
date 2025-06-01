import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Controllers/global_controller.dart';
import 'package:speak_ez/Screens/HomeScreen/home_screen.dart';
import 'package:speak_ez/Screens/Practice/practice_speaking.dart';
import 'package:speak_ez/Utils/whisper_helper.dart';

class TabBarScreen extends StatefulWidget {
  const TabBarScreen({super.key});

  @override
  State<TabBarScreen> createState() => _TabBarScreenState();
}

class _TabBarScreenState extends State<TabBarScreen> {
  final c = Get.put(GlobalController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () async {
      if (!await WhisperHelper.isModelAvailable()) {
        WhisperHelper.runSilentDownload();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: globalController.cutomTabBarController,
        physics: NeverScrollableScrollPhysics(),
        children: [HomeScreen(), PracticeSpeaking()],
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          onTap: (value) {
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
          ],
          currentIndex: globalController.currentTabIndex.value,
        ),
      ),
    );
  }
}
