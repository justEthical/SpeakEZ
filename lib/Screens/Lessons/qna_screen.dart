import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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
    }
    return PopScope(
      canPop: c.isBottomSheetOpen,
      onPopInvokedWithResult: (res, k){
        if(!c.isBottomSheetOpen){
          c.isBottomSheetOpen = true;
          c.showExitBottomSheet(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              c.isBottomSheetOpen = true;
              c.showExitBottomSheet(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
          ),
          title: Text(
            c.isUnlockTest ? lesson.lessonName : "Test Your Knowledge",
            style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              ProgressBar(),
              SizedBox(height: 15),
              Expanded(
                child: PageView.builder(
                  controller: c.questionPageController,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: c.currentQuestionList.length,
                  itemBuilder: (ctx, i) {
                    final question = c.currentQuestionList[i];
                    question.audioText != null ? ttsHelper.speak(question.audioText!) : null; 
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Q${i + 1}. ${question.question}",
                          textAlign: TextAlign.start,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        SizedBox(height: 10),
                        TranslationTextView(
                          text:
                              c
                                  .currentQuestionList[i]
                                  .questionTranslation!["Hindi"]
                                  .toString(),
                        ),
                        SizedBox(height: 10),
                        question.audioText != null 
                            ? ElevatedButton(
                              style:  ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple
                              ),
                              onPressed: () {
                                PostHogService.instance.captureClick(
                                  'listen_audio',
                                  elementType: 'button',
                                  screenName: 'qna_screen',
                                  additionalProperties: {
                                    'question_index': i,
                                    'lesson_id': lesson.id,
                                  },
                                );
                                ttsHelper.speak(
                                  question.audioText!,
                                );
                              },
                              child: Text(
                                "Listen 🔊",
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                            : SizedBox(),
                        Spacer(),
                        OptionBuilder(question: question),
                        SizedBox(height: 15),
                        ContinueButton(
                          question:
                              c.currentQuestionList[c.currentQuestionIndex.value],
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
    );
  }
}
