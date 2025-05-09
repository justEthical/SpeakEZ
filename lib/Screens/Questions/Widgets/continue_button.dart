import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Controllers/question_options_controller.dart'
    show QuestionOptionsController;
import 'package:speak_ez/Screens/Questions/result_screen.dart';

class ContinueButton extends StatelessWidget {
  const ContinueButton({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<QuestionOptionsController>();
    return SafeArea(
      child: Obx(
        () => ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            fixedSize: Size(Get.width, 55),
          ),
          onPressed:
              !c.isContinueButtonEnabled.value
                  ? null
                  : () async {
                    if (c.currentQuestionIndex.value <
                        c.currentLesson.value.questions.length - 1) {
                      c.currentQuestionIndex.value++;
                      c.questionPageController.jumpToPage(
                        c.currentQuestionIndex.value,
                      );
                      c.currentSelectedOptionIndex.value = 100;
                    } else {
                      Get.offAll(() => ResultScreen());
                    }
                  },
          child: Text("Continue", style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
