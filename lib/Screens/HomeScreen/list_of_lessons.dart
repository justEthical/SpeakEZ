import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Constants/app_data.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Controllers/global_controller.dart';
import 'package:speak_ez/Controllers/home_screen_controller.dart';
import 'package:speak_ez/Screens/Lessons/lesson_intro_screen.dart';

class ListOfLessons extends StatefulWidget {
  final String englishLevel;
  final bool isLessonLocked;
  const ListOfLessons({
    super.key,
    this.isLessonLocked = false,
    required this.englishLevel,
  });

  @override
  State<ListOfLessons> createState() => _ListOfLessonsState();
}

class _ListOfLessonsState extends State<ListOfLessons> {
  final c = Get.find<HomeScreenController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "${widget.englishLevel} ${AppStrings.levelLessons.tr}",
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyMedium?.color,
            fontSize: 24,
            fontFamily: AppStrings.nunitoFont,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: AppData.lessonNames[widget.englishLevel]!.length,
                itemBuilder: (ctx, i) {
                  final islessonCompleted = _islessonCompleted(i);
                  return Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)  ,
                      border: Border.all(color: theme.colorScheme.primary, width: 0.4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 15,
                      ),
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey.shade300,
                        child: Text(
                          (i + 1).toString(),
                          style: TextStyle(
                            color: theme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        AppData.lessonNames[widget.englishLevel]![i].toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle:
                          islessonCompleted
                              ? Row(
                                children: [
                                  Text(AppStrings.completed.tr),
                                  SizedBox(width: 8),
                                  Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 16,
                                  ),
                                ],
                              )
                              : SizedBox(),
                      trailing:
                          islessonCompleted
                              ? ElevatedButton(
                                onPressed: () {
                                  Get.to(
                                    () => LessonIntroScreen(
                                      lessonIndex: i + 1,
                                      englishLevel: widget.englishLevel,
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  AppStrings.retest.tr,
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                    fontSize: 12,
                                  ),
                                ),
                              )
                              : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.lock,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface.withOpacity(0.6),
                                    size: 20,
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface.withOpacity(0.6),
                                    size: 20,
                                  ),
                                ],
                              ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _islessonCompleted(int index) {
    if (widget.isLessonLocked) {
      return false;
    }
    final indexOfCurrentLesson = AppData.englishLevel.indexOf(
      globalController.userProfile.value.currentEnglishLevel,
    );
    final englishLevelIndex = AppData.englishLevel.indexOf(widget.englishLevel);
    if (indexOfCurrentLesson > englishLevelIndex) {
      return true;
    }
    if (indexOfCurrentLesson == englishLevelIndex) {
      return globalController.userProfile.value.currentEnglishLevelProgress >
          index;
    }
    return false;
  }
}
