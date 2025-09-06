import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speak_ez/Constants/app_assets.dart';
import 'package:speak_ez/Constants/app_data.dart';
import 'package:speak_ez/Controllers/global_controller.dart';
import 'package:speak_ez/Controllers/home_screen_controller.dart';
import 'package:speak_ez/Screens/HomeScreen/Widgets/current_lesson_progress_card.dart';
import 'package:speak_ez/Screens/HomeScreen/Widgets/english_level_container.dart';
import 'package:speak_ez/Screens/HomeScreen/Widgets/streak_and_word_count_section.dart';
import 'package:speak_ez/Screens/SettingsScreen/setting_screens.dart';
import 'package:speak_ez/Utils/whisper_helper.dart';
import 'package:speak_ez/Services/posthog_service.dart';

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
    PostHogService.instance.captureScreenView('home_screen');
    c.fetchUserDetails();
    WhisperHelper.isModelAvailable().then((isAvailable) {
      globalController.isAiModelDownloaded.value = isAvailable;
    });
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
              const StreakAndWordCountSection(),
              const SizedBox(height: 30),
              const CurrentLessonProgressCard(),
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
      title: Obx(
        () => Text(
          "Hi, ${globalController.userProfile.value.displayName}!",
          style: GoogleFonts.nunito(
            color: Colors.black87,
            fontWeight: FontWeight.w800,
            fontSize: 22,
          ),
        ),
      ),
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

class _LearnByLevelSection extends StatelessWidget {
  _LearnByLevelSection();

  final List<Map<String, dynamic>> levels = [
    {
      'level': 'A1',
      'lessons': AppData.lessonNames['A1']!.length,
      'color': const Color.fromARGB(255, 43, 154, 219),
      'isLocked': false,
    },
    {
      'level': 'A2',
      'lessons': AppData.lessonNames['A2']!.length,
      'color': const Color.fromARGB(255, 21, 84, 121),
      'isLocked': true,
    },
    {
      'level': 'B1',
      'lessons': AppData.lessonNames['B1']!.length,
      'color': const Color.fromARGB(255, 224, 148, 34),
      'isLocked': true,
    },
    {
      'level': 'B2',
      'lessons': AppData.lessonNames['B2']!.length,
      'color': const Color.fromARGB(255, 174, 106, 3),
      'isLocked': true,
    },
    {
      'level': 'C1',
      'lessons': AppData.lessonNames['C1']!.length,
      'color': const Color.fromARGB(255, 220, 81, 21),
      'isLocked': true,
    },
    {
      'level': 'C2',
      'lessons': AppData.lessonNames['C2']!.length,
      'color': const Color.fromARGB(255, 158, 55, 11),
      'isLocked': true,
    },
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
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                  ),
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
