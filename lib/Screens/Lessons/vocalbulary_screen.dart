import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Constants/app_strings.dart';
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
            AppStrings.vocabulary.tr,
            style: TextStyle(
              fontSize: 20,
              fontFamily: AppStrings.poppinsFont,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            
          ],
        ),
        body: SafeArea(
          child: Container(
            width: Get.width,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _progressIndicator(context),
                SizedBox(height: 18),
                _content(),
                _bottomButtons(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _progressIndicator(context) {
    final c = Get.find<QuestionOptionsController>();
    final vocabulary = lesson.lessonIntro?.vocabulary ?? [];
    if (vocabulary.isEmpty) return const SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ...List.generate(
          vocabulary.length,
          (e) => GestureDetector(
            onTap: () {},
            child: Obx(
              () => Container(
                width: (Get.width / vocabulary.length) - 10,
                height: 4,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 0.4),
                  color:
                      e <= c.currentWordMeaningIndex.value
                          ? Theme.of(context).colorScheme.primary
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
    final vocabulary = lesson.lessonIntro?.vocabulary ?? [];

    if (vocabulary.isEmpty) {
      return  Expanded(
        flex: 10,
        child: Center(child: Text(AppStrings.noVocabularyAvailable.tr)),
      );
    }

    return Expanded(
      flex: 10,
      child: PageView.builder(
        controller: c.wordMeaningPageController,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: vocabulary.length,
        itemBuilder: (ctx, i) {
          final vocabularyModel = vocabulary[i];
          if (c.isAutoSpeakVocabularyOn.value) {
            ttsHelper.speak(vocabularyModel.word);
          }
          return VocabularyData(vocabularyItem: vocabularyModel);
        },
      ),
    );
  }

  Widget _bottomButtons(context) {
    final c = Get.find<QuestionOptionsController>();
    final vocabulary = lesson.lessonIntro?.vocabulary ?? [];

    return Column(
      children: [
        Container(
          width: Get.width,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey, width: 1),
          ),
          child: Row(
            children: [SizedBox(width: 8,),
            Text(AppStrings.autoSpeak.tr,),
            Spacer(),
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
          ]),
        ),
        SizedBox(height: 10),
        Row(
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
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          fixedSize: Size(100, 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          AppStrings.prev.tr,
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
                if (vocabulary.isNotEmpty &&
                    c.currentWordMeaningIndex.value < vocabulary.length - 1) {
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
                backgroundColor: Theme.of(context).colorScheme.primary,
                fixedSize: Size(100, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Obx(
                () => Text(
                  vocabulary.isNotEmpty &&
                          c.currentWordMeaningIndex.value ==
                              vocabulary.length - 1
                      ? AppStrings.done.tr
                      : AppStrings.next.tr,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
