import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Screens/HomeScreen/list_of_lessons.dart';

class EnglishLevelContainer extends StatelessWidget {
  final String level;
  final int lessons;
  final Color color;
  final bool isLocked;
  const EnglishLevelContainer({
    super.key,
    required this.level,
    required this.lessons,
    required this.color,
    this.isLocked = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (!isLocked) {
          Get.to(ListOfLessons());
        }
      },
      child: Container(
        width: Get.width / 3 - 20,
        // height: 60,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  level,
                  style: TextStyle(
                    color: isLocked ? Colors.grey : Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                isLocked ? SizedBox(width: 5) : SizedBox(),
                isLocked
                    ? const Icon(Icons.lock, color: Colors.white, size: 15)
                    : SizedBox(),
              ],
            ),
            Text(
              "Lessons $lessons",
              style: TextStyle(color: isLocked ? Colors.grey : Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
