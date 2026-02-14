import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Controllers/global_controller.dart';
import 'package:speak_ez/Controllers/question_options_controller.dart';
import 'package:speak_ez/Models/lesson_model.dart';
import 'package:speak_ez/Screens/Lessons/Widgets/continue_button.dart';
import 'package:speak_ez/Screens/Lessons/Widgets/option_builder.dart';
import 'package:speak_ez/Screens/Lessons/Widgets/translation_text_view.dart';
import 'package:speak_ez/Utils/tts_helper.dart';
import 'package:speak_ez/Services/posthog_service.dart';
import 'package:speak_ez/Constants/posthog_events.dart';
import './Widgets/progress_bar.dart';

class QnaScreen extends StatelessWidget {
  final Lesson lesson;
  const QnaScreen({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<QuestionOptionsController>();
    PostHogService.instance.captureScreenView(
      'qna_screen',
      properties: {'lesson_id': lesson.id},
    );
    PostHogService.instance.capture(
      PostHogEvents.lessonQnaStarted,
      properties: {'lesson_id': lesson.id, 'lesson_name': lesson.lessonName},
    );

    if (c.isUnlockTest) {
      globalController.userProfile.value.unlockTestLastTime = DateTime.now();
      globalController.updateProfile();
    }
    return PopScope(
      canPop: c.isBottomSheetOpen,
      onPopInvokedWithResult: (res, k) {
        if (!c.isBottomSheetOpen) {
          c.isBottomSheetOpen = true;
          c.showExitBottomSheet(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              c.isBottomSheetOpen = true;
              c.showExitBottomSheet(context);
            },
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
          ),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.tertiary,
                      Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.quiz_rounded, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  c.isUnlockTest ? lesson.lessonName : AppStrings.testYourKnowledge.tr,
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: AppStrings.poppinsFont,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const ProgressBar(),
                const SizedBox(height: 16),
                Expanded(
                  child: PageView.builder(
                    controller: c.questionPageController,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: c.currentQuestionList.length,
                    itemBuilder: (ctx, i) {
                      final question = c.currentQuestionList[i];
                      question.audioText != null ? ttsHelper.speak(question.audioText!) : null;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.08),
                                  Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.02),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.15),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.tertiary,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        "${AppStrings.question.tr} ${i + 1}",
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    if (question.audioText != null)
                                      InkWell(
                                        onTap: () {
                                          PostHogService.instance.captureClick(
                                            'listen_audio',
                                            elementType: 'button',
                                            screenName: 'qna_screen',
                                            additionalProperties: {
                                              'question_index': i,
                                              'lesson_id': lesson.id,
                                            },
                                          );
                                          ttsHelper.speak(question.audioText!);
                                        },
                                        borderRadius: BorderRadius.circular(12),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.15),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.volume_up_rounded,
                                                size: 18,
                                                color: Theme.of(context).colorScheme.tertiary,
                                              ),
                                              const SizedBox(width: 6),
                                              Text(
                                                AppStrings.listen.tr,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                  color: Theme.of(context).colorScheme.tertiary,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  question.question,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: AppStrings.poppinsFont,
                                    fontWeight: FontWeight.w600,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (c.currentQuestionList[i].questionTranslation != null) ...[
                            const SizedBox(height: 12),
                            TranslationTextView(
                              text: c.currentQuestionList[i].questionTranslation!,
                            ),
                          ],
                          const Spacer(),
                          OptionBuilder(question: question),
                          const SizedBox(height: 16),
                          ContinueButton(
                            question: c.currentQuestionList[c.currentQuestionIndex.value],
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
