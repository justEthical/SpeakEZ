import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:speak_ez/Constants/app_assets.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Controllers/global_controller.dart';
import 'package:speak_ez/Controllers/question_options_controller.dart';

class AnswerResultBottomSheet extends StatelessWidget {
  final String correctAnswer;
  final bool isAnswerCorrect;
  const AnswerResultBottomSheet({
    super.key,
    required this.correctAnswer,
    required this.isAnswerCorrect,
  });

  @override
  Widget build(BuildContext context) {
    final c = Get.find<QuestionOptionsController>();
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text(
              isAnswerCorrect ? 'Correct Answer' : 'Wrong Answer',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: isAnswerCorrect ? Colors.green : Colors.red,
                fontFamily: AppStrings.nunitoFont,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 60,
              width: 60,
              child: Lottie.asset(
                isAnswerCorrect
                    ? AppAssets.correctAnswer
                    : AppAssets.wrongAnswer,
                decoder: globalController.customDecoder,
                repeat: isAnswerCorrect,
              ),
            ),
            SizedBox(height: 10),
            isAnswerCorrect
                ? SizedBox()
                : Text(
                  "Correct Answer: $correctAnswer",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                    fontFamily: AppStrings.nunitoFont,
                  ),
                ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.back();
                c.moveToNextQuestion();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                fixedSize: Size(Get.width - 30, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(45),
                ),
              ),
              child: Text(
                "Next",
                style: TextStyle(
                  fontFamily: AppStrings.nunitoFont,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
