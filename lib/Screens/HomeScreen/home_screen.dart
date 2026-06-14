import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Constants/app_data.dart';
import 'package:speak_ez/Constants/app_assets.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Controllers/global_controller.dart';
import 'package:speak_ez/Controllers/home_screen_controller.dart';
import 'package:speak_ez/Screens/HomeScreen/Widgets/current_lesson_progress_card.dart';
import 'package:speak_ez/Screens/HomeScreen/Widgets/english_level_container.dart';
import 'package:speak_ez/Screens/HomeScreen/Widgets/home_palette.dart';
import 'package:speak_ez/Screens/HomeScreen/Widgets/streak_and_word_count_section.dart';
import 'package:speak_ez/Screens/HomeScreen/Widgets/practice_cards_section.dart';
import 'package:speak_ez/Services/posthog_service.dart';

import 'Widgets/level_info_bottom_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final HomeScreenController c = Get.put(HomeScreenController());

  late AnimationController _staggerController;

  @override
  void initState() {
    super.initState();
    PostHogService.instance.captureScreenView('home_screen');
    c.fetchUserDetails();

    _staggerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _staggerController.forward();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Get.updateLocale(Locale(globalController.userProfile.value.appLanguage));
    });
  }

  @override
  void dispose() {
    _staggerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = HomePalette(context);
    return Scaffold(
      backgroundColor: palette.background,
      appBar: _HomeAppBar(animationController: _staggerController),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _AnimatedSection(
                delay: 0,
                controller: _staggerController,
                child: const StreakAndWordCountSection(),
              ),
              const SizedBox(height: 16),
              _AnimatedSection(
                delay: 150,
                controller: _staggerController,
                child: const CurrentLessonProgressCard(),
              ),
              const SizedBox(height: 24),
              _AnimatedSection(
                delay: 300,
                controller: _staggerController,
                child: const PracticeCardsSection(),
              ),
              const SizedBox(height: 28),
              _AnimatedSection(
                delay: 450,
                controller: _staggerController,
                child: _LearnByLevelSection(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimatedSection extends StatelessWidget {
  final int delay;
  final AnimationController controller;
  final Widget child;

  const _AnimatedSection({
    required this.delay,
    required this.controller,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              delay / 1500,
              (delay + 800) / 1500,
              curve: Curves.easeOutCubic,
            ),
          ),
        );

        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.2),
              end: Offset.zero,
            ).animate(animation),
            child: child!,
          ),
        );
      },
      child: child,
    );
  }
}

class _HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AnimationController animationController;

  const _HomeAppBar({required this.animationController});

  @override
  Widget build(BuildContext context) {
    final palette = HomePalette(context);

    return AppBar(
      elevation: 0,
      backgroundColor: palette.background,
      titleSpacing: 16,
      title: FadeTransition(
        opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: animationController,
            curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
          ),
        ),
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-0.3, 0),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: animationController,
              curve: const Interval(0.0, 0.5, curve: Curves.easeOutCubic),
            ),
          ),
          child: Obx(() {
            final profile = globalController.userProfile.value;
            return Row(
              children: [
                _Avatar(palette: palette, photoUrl: profile.photoUrl),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppStrings.welcomeBack.tr,
                      style: TextStyle(
                        color: palette.onSurfaceVariant,
                        fontFamily: AppStrings.nunitoFont,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      "${profile.displayName}!",
                      style: TextStyle(
                        color: palette.onSurface,
                        fontFamily: AppStrings.nunitoFont,
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: animationController,
                curve: const Interval(0.2, 0.7, curve: Curves.elasticOut),
              ),
            ),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: palette.pillColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(AppAssets.gem, width: 18, height: 18),
                  const SizedBox(width: 6),
                  Obx(
                    () => Text(
                      globalController.userProfile.value.gems.toString(),                    
                      style: TextStyle(
                        color: palette.onSurface,
                        fontFamily: AppStrings.nunitoFont,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64);
}

class _Avatar extends StatelessWidget {
  final HomePalette palette;
  final String? photoUrl;

  const _Avatar({required this.palette, this.photoUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: palette.primary, width: 2),
      ),
      child: ClipOval(
        child: (photoUrl != null && photoUrl!.isNotEmpty)
            ? Image.network(
                photoUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _fallback(),
              )
            : _fallback(),
      ),
    );
  }

  Widget _fallback() => Container(
        color: palette.primary.withValues(alpha: 0.15),
        child: Icon(Icons.person, color: palette.primary, size: 24),
      );
}

class _LearnByLevelSection extends StatelessWidget {
  _LearnByLevelSection();

  final List<Map<String, dynamic>> levels = [
    {
      'level': 'A1',
      'lessons': AppData.lessonNames['A1']!.length,
      'color': const Color.fromARGB(255, 43, 154, 219),
    },
    {
      'level': 'A2',
      'lessons': AppData.lessonNames['A2']!.length,
      'color': const Color.fromARGB(255, 21, 84, 121),
    },
    {
      'level': 'B1',
      'lessons': AppData.lessonNames['B1']!.length,
      'color': const Color.fromARGB(255, 224, 148, 34),
    },
    {
      'level': 'B2',
      'lessons': AppData.lessonNames['B2']!.length,
      'color': const Color.fromARGB(255, 174, 106, 3),
    },
    {
      'level': 'C1',
      'lessons': AppData.lessonNames['C1']!.length,
      'color': const Color.fromARGB(255, 220, 81, 21),
    },
    {
      'level': 'C2',
      'lessons': AppData.lessonNames['C2']!.length,
      'color': const Color.fromARGB(255, 158, 55, 11),
    },
  ];

  void _showLevelInfoSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                AppStrings.learnByLevel.tr,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  fontFamily: AppStrings.nunitoFont,
                  color: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => _showLevelInfoSheet(context),
                child: Text(
                  AppStrings.seeAll.tr,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
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
              final englishLevelIndex = AppData.englishLevel.indexOf(
                globalController.userProfile.value.currentEnglishLevel,
              );
              final isLevelLocked = index > englishLevelIndex;
              return Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: EnglishLevelContainer(
                  level: item['level'],
                  lessons: item['lessons'],
                  color: item['color'],
                  isLocked: isLevelLocked,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
