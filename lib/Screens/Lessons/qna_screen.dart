import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speak_ez/Controllers/question_options_controller.dart';
import 'package:speak_ez/Models/lesson_model.dart';
import 'package:speak_ez/Screens/Lessons/Widgets/continue_button.dart';
import 'package:speak_ez/Screens/Lessons/Widgets/option_builder.dart';
import 'package:speak_ez/Screens/Lessons/Widgets/translation_text_view.dart';
import 'package:speak_ez/Utils/tts_helper.dart';
import './Widgets/progress_bar.dart';

class QnaScreen extends StatelessWidget {
  final Lesson lesson;
  const QnaScreen({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<QuestionOptionsController>();
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
            "Test Your Knowledge",
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
