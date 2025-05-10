import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Constants/app_assets.dart';
import 'package:speak_ez/Controllers/question_options_controller.dart'
    show QuestionOptionsController;
import 'package:speak_ez/Models/questions_model.dart';
import 'package:speak_ez/Screens/Questions/result_screen.dart';

class ContinueButton extends StatelessWidget {
  final Question question;
  const ContinueButton({super.key, required this.question});

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
                    switch (question.type) {
                      case QuestionType.sentenceRearranging:
                        final isAnswerCorrect = c.comparing2Lists(
                          c.sentenceRearrangeTempList,
                          question.answer,
                        );
                        if (isAnswerCorrect) {
                          FlameAudio.play(AppAssets.correct);
                        } else {
                          FlameAudio.play(AppAssets.incorrect);
                        }
                        c.showAnswerResultBottomSheet(
                          isAnswerCorrect: isAnswerCorrect,
                          correctAnswer: question.answer.join(" "),
                        );
                        break;
                      default:
                        final isAnswerCorrect =
                            c.currentSelectedOptionIndex.value ==
                            question.answer;
                        if (isAnswerCorrect) {
                          FlameAudio.play(AppAssets.correct);
                        } else {
                          FlameAudio.play(AppAssets.incorrect);
                        }
                        c.showAnswerResultBottomSheet(
                          isAnswerCorrect: isAnswerCorrect,
                          correctAnswer: question.options[question.answer],
                        );
                        break;
                    }
                  },
          child: Text("Check", style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
