import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speak_ez/Controllers/question_options_controller.dart';
import 'package:speak_ez/Screens/Lessons/Widgets/vocabulary_data.dart';
import 'package:speak_ez/Screens/Lessons/grammer_tips_screen.dart';
import 'package:speak_ez/Utils/tts_helper.dart';

import '../../Models/lesson_model.dart' show Lesson;

class VocalbularyScreen extends StatelessWidget {
  final Lesson lesson;
  const VocalbularyScreen({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<QuestionOptionsController>();
    c.currentWordMeaningIndex.value = 0;
    c.isBottomSheetOpen = false;
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
          leading: IconButton(
            onPressed: () {
              c.isBottomSheetOpen = true;
              c.showExitBottomSheet(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
          ),
          title: Text(
            "Vocalbulary",
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            Transform.scale(
              scale: 0.8,
              child: Obx(
                () => Switch(
                  value: c.isAutoSpeakVocabularyOn.value,
                  onChanged: (val) {
                    c.isAutoSpeakVocabularyOn.value = val;
                  },
                ),
              ),
            ),
          ],
        ),
        body: Container(
          width: Get.width,
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _progressIndicator(),
              SizedBox(height: 18),
              _content(),
              _bottomButtons(),
            ],
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
          lesson.lessonIntro.vocabulary.length,
          (e) => GestureDetector(
            onTap: () {},
            child: Obx(
              () => Container(
                width: (Get.width / lesson.lessonIntro.vocabulary.length) - 10,
                height: 4,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 0.4),
                  color:
                      e <= c.currentWordMeaningIndex.value
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
      flex: 10,
      child: PageView.builder(
        controller: c.wordMeaningPageController,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: lesson.lessonIntro.vocabulary.length,
        itemBuilder: (ctx, i) {
          final vocabularyModel = lesson.lessonIntro.vocabulary[i];
          if(c.isAutoSpeakVocabularyOn.value){
            ttsHelper.speak(vocabularyModel.word);
          }
          return VocabularyData(
            vocabularyItem: vocabularyModel,
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
              c.currentWordMeaningIndex.value == 0
                  ? SizedBox()
                  : ElevatedButton(
                    onPressed: () {
                      c.wordMeaningPageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.linear,
                      );
                      c.currentWordMeaningIndex.value--;
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
            if (c.currentWordMeaningIndex.value <
                lesson.lessonIntro.vocabulary.length - 1) {
              c.wordMeaningPageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.linear,
              );
              c.currentWordMeaningIndex.value++;
            } else {
              Get.off(GrammerTipsScreen(lesson: lesson));
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
              c.currentWordMeaningIndex.value ==
                      lesson.lessonIntro.vocabulary.length - 1
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
