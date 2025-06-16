import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Controllers/global_controller.dart';

class CurrentLessonProgress extends StatelessWidget {
  const CurrentLessonProgress({super.key});

  @override
  Widget build(BuildContext context) {    return Stack(
      children: [
        Container(
          height: 10,
          width: Get.width - 54,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 232, 196, 255),
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            width:
                (Get.width - 54) /
                25 *
                (globalController.userProfile.value.currentLessonProgress + 1),

            height: 10,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 75, 10, 120),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
      ],
    );
  }
}
