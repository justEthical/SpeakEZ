import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Constants/app_colors.dart';
import 'package:speak_ez/Constants/app_data.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Controllers/global_controller.dart';
import 'package:speak_ez/Controllers/home_screen_controller.dart';

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
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Lessons",
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontFamily: AppStrings.nunitoFont,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const SizedBox(height: 10),
            // SingleChildScrollView(
            //   scrollDirection: Axis.horizontal,
            //   child: Row(
            //     children: [
            //       ...List.generate(
            //         CEFRLevel.values.length,
            //         (index) => Obx(
            //           () => GestureDetector(
            //             onTap: () {
            //               c.currenEnglishLessonLevel.value =
            //                   CEFRLevel.values[index].name;
            //             },
            //             child: Container(
            //               padding: const EdgeInsets.symmetric(
            //                 horizontal: 20,
            //                 vertical: 10,
            //               ),
            //               margin: const EdgeInsets.only(right: 10),
            //               decoration: BoxDecoration(
            //                 color:
            //                     c.currenEnglishLessonLevel.value ==
            //                             CEFRLevel.values[index].name
            //                         ? AppColors.primaryColor
            //                         : Colors.grey[200],
            //                 borderRadius: BorderRadius.circular(20),
            //               ),
            //               child: Text(
            //                 CEFRLevel.values[index].name,
            //                 style: TextStyle(
            //                   color:
            //                       c.currenEnglishLessonLevel.value ==
            //                               CEFRLevel.values[index].name
            //                           ? Colors.white
            //                           : Colors.black,
            //                   fontWeight: FontWeight.bold,
            //                 ),
            //               ),
            //             ),
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: AppData.lessonNames[widget.englishLevel]!.length,
                itemBuilder: (ctx, i) {
                  final islessonCompleted =
                      (i <
                      globalController
                          .userProfile
                          .value
                          .currentEnglishLevelProgress) && !widget.isLessonLocked;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
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
                        backgroundColor: AppColors.primaryColor.withOpacity(
                          0.1,
                        ),
                        child: Text(
                          (i + 1).toString(),
                          style: const TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        AppData
                            .lessonNames[widget.englishLevel]![i]
                            .toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(widget.englishLevel),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            islessonCompleted ? Icons.check_circle : Icons.lock,
                            color:
                                islessonCompleted ? Colors.green : Colors.grey,
                            size: 20,
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey,
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
}
