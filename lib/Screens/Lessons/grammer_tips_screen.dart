import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speak_ez/Controllers/question_options_controller.dart';
import 'package:speak_ez/Models/lesson_model.dart';
import 'package:speak_ez/Screens/Lessons/Widgets/translation_text_view.dart';
import 'package:speak_ez/Screens/Lessons/qna_screen.dart';

class GrammerTipsScreen extends StatelessWidget {
  final Lesson lesson;
  const GrammerTipsScreen({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<QuestionOptionsController>();
    c.currentGrammerTipIndex.value = 0;
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
            "Grammer Tips",
            style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        body: Container(
          width: Get.width,
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Column(
            children: [_progressIndicator(), _content(), _bottomButtons()],
          ),
        ),
      ),
    );
  }

  Widget _progressIndicator() {
    final c = Get.find<QuestionOptionsController>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ...List.generate(
          lesson.lessonIntro.grammarTips.length,
          (e) => GestureDetector(
            onTap: () {},
            child: Obx(
              () => Container(
                width:
                    ((Get.width - 30) / lesson.lessonIntro.grammarTips.length) -
                    10,
                height: 4,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 0.4),
                  color:
                      e <= c.currentGrammerTipIndex.value
                          ? Colors.deepPurple
                          : Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _content() {
    final c = Get.find<QuestionOptionsController>();
    return Expanded(
      child: PageView.builder(
        physics: const NeverScrollableScrollPhysics(),
        controller: c.grammerTipPageController,
        itemCount: lesson.lessonIntro.grammarTips.length,
        itemBuilder: (ctx, i) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 18),
              Text(
                lesson.lessonIntro.grammarTips[i].title,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                lesson.lessonIntro.grammarTips[i].explanation,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 10),
              TranslationTextView(
                text:
                    lesson
                        .lessonIntro
                        .grammarTips[i]
                        .explanationTranslation!["Hindi"]
                        .toString(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _bottomButtons() {
    final c = Get.find<QuestionOptionsController>();
    return Row(
      children: [
        Obx(
          () =>
              c.currentGrammerTipIndex.value == 0
                  ? SizedBox()
                  : ElevatedButton(
                    onPressed: () {
                      c.grammerTipPageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.linear,
                      );
                      c.currentGrammerTipIndex.value--;
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      fixedSize: Size(100, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Prev",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
        ),
        Spacer(),
        ElevatedButton(
          onPressed: () {
            if (c.currentGrammerTipIndex.value <
                lesson.lessonIntro.grammarTips.length - 1) {
              c.grammerTipPageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.linear,
              );
              c.currentGrammerTipIndex.value++;
            } else {
              c.buildQnaList(lesson);
              Get.off(QnaScreen(lesson: lesson));
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            fixedSize: Size(100, 40),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Obx(
            () => Text(
              c.currentGrammerTipIndex.value ==
                      lesson.lessonIntro.grammarTips.length - 1
                  ? "Done"
                  : "Next",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
