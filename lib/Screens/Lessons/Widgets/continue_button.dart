import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Constants/app_assets.dart';
import 'package:speak_ez/Controllers/global_controller.dart';
import 'package:speak_ez/Controllers/question_options_controller.dart'
    show QuestionOptionsController;
import 'package:speak_ez/Models/lesson_model.dart';

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
            backgroundColor: Theme.of(context).colorScheme.onSurface,
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
                        _playAudio(isAnswerCorrect, c);
                        c.showAnswerResultBottomSheet(
                          isAnswerCorrect: isAnswerCorrect,
                          correctAnswer: question.answer.join(" "),
                        );
                        break;
                      case QuestionType.speaking:
                        final speakingAccuracy = c.calculateAccuracy(
                          question.answer,
                          globalController.transcriptionText.value.trim(),
                        );
                        _playAudio(
                          c.isSpeakingQuestionAccurate(speakingAccuracy),
                          c,
                        );
                        c.showAnswerResultBottomSheet(
                          isAnswerCorrect: c.isSpeakingQuestionAccurate(
                            speakingAccuracy,
                          ),
                          correctAnswer: question.answer,
                        );
                        break;
                      default:
                        final isAnswerCorrect =
                            c.currentSelectedOptionIndex.value ==
                            question.answer;
                        _playAudio(isAnswerCorrect, c);
                        c.showAnswerResultBottomSheet(
                          isAnswerCorrect: isAnswerCorrect,
                          correctAnswer: question.options![question.answer],
                        );
                        break;
                    }
                  },
          child: Text(
            "Check",
            style: TextStyle(
              color: Theme.of(context).scaffoldBackgroundColor,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }

  void _playAudio(bool isAnswerCorrect, QuestionOptionsController c) {
    if (isAnswerCorrect) {
      c.correctAnswer++;
      FlameAudio.play(AppAssets.correct);
    } else {
      FlameAudio.play(AppAssets.incorrect);
    }
  }
}
