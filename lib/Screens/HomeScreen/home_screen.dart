import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Constants/app_assets.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Controllers/global_controller.dart';
import 'package:speak_ez/Controllers/home_screen_controller.dart';
import 'package:speak_ez/Screens/HomeScreen/Widgets/current_lesson_progress.dart';
import 'package:speak_ez/Screens/HomeScreen/Widgets/english_level_container.dart';
import 'package:speak_ez/Screens/HomeScreen/Widgets/steak_and_progress_card.dart';
import 'package:speak_ez/Screens/Questions/listening_screen.dart';
import 'package:speak_ez/Screens/SettingsScreen/setting_screens.dart';

import 'Widgets/level_info_bottom_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final c = Get.put(HomeScreenController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    c.fetchUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(
          "Hi, ${globalController.userProfile.value.name}!",
          style: TextStyle(
            color: Colors.white,
            fontFamily: AppStrings.nunitoFont,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          InkWell(
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color.fromARGB(255, 74, 42, 165),
              ),
              child: SvgPicture.asset(AppAssets.settings, color: Colors.white),
            ),
            onTap: () {
              Get.to(() => SettingScreens());
            },
          ),
          SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 15, left: 15, right: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Your Progress",
                style: TextStyle(
                  fontFamily: AppStrings.nunitoFont,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  SteakAndProgressCard(
                    title: "Current Streak",
                    icon: AppAssets.flame,
                    iconColor: Colors.deepOrange,
                    progress: "7 days",
                  ),
                  SizedBox(width: 20),
                  SteakAndProgressCard(
                    title: "Words Learned",
                    icon: AppAssets.medal,
                    iconColor: Colors.deepPurple,
                    progress: "120",
                  ),
                ],
              ),

              SizedBox(height: 20),

              Container(
                width: Get.width - 30,
                // height: 100,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 0,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Current Level Progress",
                      style: TextStyle(
                        fontFamily: AppStrings.nunitoFont,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          "Introduction",
                          style: TextStyle(
                            fontFamily: AppStrings.nunitoFont,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Spacer(),
                        Text("32%"),
                      ],
                    ),

                    SizedBox(height: 8),
                    CurrentLessonProgress(),
                    SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () {
                        Get.to(ListeningScreen());
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(Get.width, 50),
                        backgroundColor: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "Continue Learning",
                        style: TextStyle(
                          fontFamily: AppStrings.nunitoFont,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    "Learn by level",
                    style: TextStyle(
                      fontFamily: AppStrings.nunitoFont,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        showDragHandle: true, // ✅ Native drag handle!
                        backgroundColor: Colors.white,
                        isScrollControlled: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        builder: (context) => LevelBottomSheet(),
                      );
                    },
                    icon: Icon(Icons.help, color: Colors.deepPurple, size: 20),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  EnglishLevelContainer(
                    level: 'A1',
                    lessons: 19,
                    color: const Color.fromARGB(255, 43, 154, 219),
                  ),
                  EnglishLevelContainer(
                    level: 'B1',
                    lessons: 19,
                    color: const Color.fromARGB(255, 224, 148, 34),
                    isLocked: true,
                  ),
                  EnglishLevelContainer(
                    level: 'C1',
                    lessons: 19,
                    color: const Color.fromARGB(255, 220, 81, 21),
                    isLocked: true,
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  EnglishLevelContainer(
                    level: 'A2',
                    lessons: 19,
                    color: const Color.fromARGB(255, 21, 84, 121),
                    isLocked: true,
                  ),
                  EnglishLevelContainer(
                    level: 'B2',
                    lessons: 19,
                    color: const Color.fromARGB(255, 174, 106, 3),
                    isLocked: true,
                  ),
                  EnglishLevelContainer(
                    level: 'C2',
                    lessons: 19,
                    color: const Color.fromARGB(255, 158, 55, 11),
                    isLocked: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
