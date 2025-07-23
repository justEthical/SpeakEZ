import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speak_ez/Constants/app_assets.dart';
import 'package:speak_ez/Constants/app_data.dart';
import 'package:speak_ez/Controllers/global_controller.dart';
import 'package:speak_ez/Controllers/home_screen_controller.dart';
import 'package:speak_ez/Controllers/question_options_controller.dart';
import 'package:speak_ez/Screens/HomeScreen/Widgets/english_level_container.dart';
import 'package:speak_ez/Screens/Lessons/lesson_intro_screen.dart';
import 'package:speak_ez/Screens/SettingsScreen/setting_screens.dart';
import 'package:speak_ez/Utils/custom_loader.dart';

import 'Widgets/level_info_bottom_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeScreenController c = Get.put(HomeScreenController());

  @override
  void initState() {
    super.initState();
    c.fetchUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: const _HomeAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _ProgressSection(),
              const SizedBox(height: 30),
              const _CurrentLevelProgressCard(),
              const SizedBox(height: 30),
              _LearnByLevelSection(),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _HomeAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFF5F6FA), // Match body background
      elevation: 0,
      title: Obx(() => Text(
            "Hi, ${globalController.userProfile.value.displayName}!",
            style: GoogleFonts.nunito(
              color: Colors.black87,
              fontWeight: FontWeight.w800,
              fontSize: 22,
            ),
          )),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: IconButton(
            onPressed: () => Get.to(() => const SettingScreens()),
            icon: SvgPicture.asset(AppAssets.settings, color: Colors.black54),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _ProgressSection extends StatelessWidget {
  const _ProgressSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Obx(() => Row(
                children: [
                  _buildProgressCard(
                    context,
                    title: "Current Streak",
                    icon: AppAssets.flame,
                    progress: "${globalController.userProfile.value.currentStreak} days",
                    color: Colors.deepOrange,
                  ),
                  const SizedBox(width: 20),
                  _buildProgressCard(
                    context,
                    title: "Words Learned",
                    icon: AppAssets.medal,
                    progress: "120", // Hardcoded value
                    color: Colors.deepPurple,
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Widget _buildProgressCard(BuildContext context, {required String title, required String icon, required String progress, required Color color}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(icon, color: color, width: 30, height: 30),
            const SizedBox(height: 15),
            Text(
              title,
              style: GoogleFonts.nunito(
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              progress,
              style: GoogleFonts.nunito(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CurrentLevelProgressCard extends StatelessWidget {
  const _CurrentLevelProgressCard();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Colors.deepPurple, Color(0xFF4A90E2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurple.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Obx(() {
          final userProfile = globalController.userProfile.value;
          final lessonNames = AppData.lessonNames[userProfile.currentEnglishLevel] ?? [];
          final progress = lessonNames.isNotEmpty
              ? (userProfile.currentEnglishLevelProgress / lessonNames.length)
              : 0.0;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Current Level: ${userProfile.currentEnglishLevel}",
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                lessonNames.isNotEmpty ? lessonNames[userProfile.currentEnglishLevelProgress] : "Introduction",
                style: GoogleFonts.nunito(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 10,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Text(
                    "${(progress * 100).toStringAsFixed(0)}%",
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: () async {
                  final c = Get.put(QuestionOptionsController());
                  CustomLoader.showLoader();
                  final lesson = await c.setCurrentLesson();
                  CustomLoader.hideLoader();
                  Get.to(() => LessonIntroScreen(lesson: lesson));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.deepPurple,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  textStyle: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                child: const Text("Continue Learning"),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _LearnByLevelSection extends StatelessWidget {
  _LearnByLevelSection();

  final List<Map<String, dynamic>> levels = [
    {'level': 'A1', 'lessons': 19, 'color': const Color.fromARGB(255, 43, 154, 219), 'isLocked': false},
    {'level': 'A2', 'lessons': 19, 'color': const Color.fromARGB(255, 21, 84, 121), 'isLocked': true},
    {'level': 'B1', 'lessons': 19, 'color': const Color.fromARGB(255, 224, 148, 34), 'isLocked': true},
    {'level': 'B2', 'lessons': 19, 'color': const Color.fromARGB(255, 174, 106, 3), 'isLocked': true},
    {'level': 'C1', 'lessons': 19, 'color': const Color.fromARGB(255, 220, 81, 21), 'isLocked': true},
    {'level': 'C2', 'lessons': 19, 'color': const Color.fromARGB(255, 158, 55, 11), 'isLocked': true},
  ];

  void _showLevelInfoSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const LevelBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            children: [
              Text(
                "Learn by level",
                style: GoogleFonts.nunito(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black.withOpacity(0.7),
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => _showLevelInfoSheet(context),
                child: const Text(
                  "See all",
                  style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 120, // Give a fixed height to the horizontal list
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: levels.length,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemBuilder: (context, index) {
              final item = levels[index];
              return Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: EnglishLevelContainer(
                  level: item['level'],
                  lessons: item['lessons'],
                  color: item['color'],
                  isLocked: item['isLocked'],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}