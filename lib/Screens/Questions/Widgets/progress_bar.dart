import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Controllers/question_options_controller.dart';

class ProgressBar extends StatelessWidget {
  const ProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<QuestionOptionsController>();
    return Stack(
      children: [
        Obx(
          () => AnimatedContainer(
            duration: Duration(milliseconds: 300),
            height: 10,
            width:
                ((Get.width - 30) / c.currentLesson.value.questions.length) *
                (c.currentQuestionIndex.value + 1),
            decoration: BoxDecoration(
              color: Colors.deepPurple,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        Container(
          height: 10,
          decoration: BoxDecoration(
            color: Colors.deepPurple.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ],
    );
  }
}
