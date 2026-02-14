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
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              c.isBottomSheetOpen = true;
              c.showExitBottomSheet(context);
            },
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: Theme.of(context).colorScheme.primary,
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
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.primary.withOpacity(0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.menu_book_rounded, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 10),
              Text(
                AppStrings.vocabulary.tr,
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: AppStrings.poppinsFont,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: Container(
            width: Get.width,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _progressIndicator(context),
                const SizedBox(height: 16),
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

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() => Text(
                "${AppStrings.word.tr} ${c.currentWordMeaningIndex.value + 1} of ${vocabulary.length}",
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: AppStrings.poppinsFont,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              )),
              Obx(() => Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "${((c.currentWordMeaningIndex.value + 1) / vocabulary.length * 100).toInt()}%",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              )),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Obx(() => LinearProgressIndicator(
              value: (c.currentWordMeaningIndex.value + 1) / vocabulary.length,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
              minHeight: 8,
            )),
          ),
        ],
      ),
    );
  }

  Widget _content() {
    final c = Get.find<QuestionOptionsController>();
    final vocabulary = lesson.lessonIntro?.vocabulary ?? [];

    if (vocabulary.isEmpty) {
      return Expanded(
        flex: 10,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.library_books_outlined,
                size: 64,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                AppStrings.noVocabularyAvailable.tr,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                  fontFamily: AppStrings.poppinsFont,
                ),
              ),
            ],
          ),
        ),
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary.withOpacity(0.08),
                Theme.of(context).colorScheme.primary.withOpacity(0.03),
              ],
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.volume_up_rounded,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  AppStrings.autoSpeak.tr,
                  style: TextStyle(
                    fontFamily: AppStrings.poppinsFont,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
              Obx(
                () => Switch.adaptive(
                  value: c.isAutoSpeakVocabularyOn.value,
                  activeColor: Theme.of(context).colorScheme.primary,
                  onChanged: (val) {
                    c.isAutoSpeakVocabularyOn.value = val;
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Obx(
              () => c.currentWordMeaningIndex.value == 0
                  ? const SizedBox(width: 100)
                  : Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          c.wordMeaningPageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                          c.currentWordMeaningIndex.value--;
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Theme.of(context).colorScheme.primary,
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 1.5,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        icon: const Icon(Icons.arrow_back_rounded, size: 20),
                        label: Text(
                          AppStrings.prev.tr,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            fontFamily: AppStrings.poppinsFont,
                          ),
                        ),
                      ),
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Obx(
                () => ElevatedButton.icon(
                  onPressed: () {
                    if (vocabulary.isNotEmpty &&
                        c.currentWordMeaningIndex.value < vocabulary.length - 1) {
                      c.wordMeaningPageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                      c.currentWordMeaningIndex.value++;
                    } else {
                      Get.off(GrammerTipsScreen(lesson: lesson));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: Icon(
                    vocabulary.isNotEmpty &&
                            c.currentWordMeaningIndex.value == vocabulary.length - 1
                        ? Icons.check_rounded
                        : Icons.arrow_forward_rounded,
                    size: 20,
                  ),
                  label: Text(
                    vocabulary.isNotEmpty &&
                            c.currentWordMeaningIndex.value == vocabulary.length - 1
                        ? AppStrings.done.tr
                        : AppStrings.next.tr,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      fontFamily: AppStrings.poppinsFont,
                    ),
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