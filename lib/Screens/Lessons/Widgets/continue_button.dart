import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Constants/app_assets.dart';
import 'package:speak_ez/Constants/app_strings.dart';
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
        () {
          final isEnabled = c.isContinueButtonEnabled.value;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: Get.width,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: isEnabled
                  ? LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.tertiary,
                        Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.85),
                      ],
                    )
                  : null,
              color: isEnabled ? null : Colors.grey.shade300,
              boxShadow: isEnabled
                  ? [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.35),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ]
                  : null,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: !isEnabled
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
                borderRadius: BorderRadius.circular(16),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle_outline_rounded,
                        color: isEnabled ? Colors.white : Colors.grey.shade500,
                        size: 22,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        AppStrings.check.tr,
                        style: TextStyle(
                          color: isEnabled ? Colors.white : Colors.grey.shade500,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: AppStrings.poppinsFont,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
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
