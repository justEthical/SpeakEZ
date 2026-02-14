import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Constants/app_strings.dart';
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
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: Theme.of(context).colorScheme.secondary,
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
                      Theme.of(context).colorScheme.secondary,
                      Theme.of(context).colorScheme.secondary.withOpacity(0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.lightbulb_rounded, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 10),
              Text(
                AppStrings.grammarTips.tr,
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
              children: [
                _progressIndicator(context),
                const SizedBox(height: 16),
                _content(context),
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
    final grammarTips = lesson.lessonIntro?.grammarTips ?? [];
    if (grammarTips.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() => Text(
                "${AppStrings.tip.tr} ${c.currentGrammerTipIndex.value + 1} of ${grammarTips.length}",
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: AppStrings.poppinsFont,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              )),
              Obx(() => Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "${((c.currentGrammerTipIndex.value + 1) / grammarTips.length * 100).toInt()}%",
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
              value: (c.currentGrammerTipIndex.value + 1) / grammarTips.length,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.secondary,
              ),
              minHeight: 8,
            )),
          ),
        ],
      ),
    );
  }

  Widget _content(BuildContext context) {
    final c = Get.find<QuestionOptionsController>();
    final grammarTips = lesson.lessonIntro?.grammarTips ?? [];
    if (grammarTips.isEmpty) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lightbulb_outline_rounded,
                size: 64,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                AppStrings.noGrammarTipsAvailable.tr,
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
      child: PageView.builder(
        physics: const NeverScrollableScrollPhysics(),
        controller: c.grammerTipPageController,
        itemCount: grammarTips.length,
        itemBuilder: (ctx, i) {
          final tip = grammarTips[i];
          final hindiTranslation = tip.explanationTranslation ?? "";

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).colorScheme.secondary.withOpacity(0.08),
                        Theme.of(context).colorScheme.secondary.withOpacity(0.02),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.secondary.withOpacity(0.15),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondary.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.tips_and_updates_rounded,
                              color: Theme.of(context).colorScheme.secondary,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              tip.title,
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: AppStrings.poppinsFont,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          tip.explanation,
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: AppStrings.poppinsFont,
                            fontWeight: FontWeight.w500,
                            height: 1.6,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (hindiTranslation.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  TranslationTextView(text: hindiTranslation),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _bottomButtons(context) {
    final c = Get.find<QuestionOptionsController>();
    final grammarTips = lesson.lessonIntro?.grammarTips ?? [];

    return Row(
      children: [
        Obx(
          () => c.currentGrammerTipIndex.value == 0
              ? const SizedBox(width: 100)
              : Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      c.grammerTipPageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                      c.currentGrammerTipIndex.value--;
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.secondary,
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.secondary,
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
                if (grammarTips.isNotEmpty &&
                    c.currentGrammerTipIndex.value < grammarTips.length - 1) {
                  c.grammerTipPageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                  c.currentGrammerTipIndex.value++;
                } else {
                  c.buildQnaList(lesson);
                  c.qnaStartTime = DateTime.now();
                  Get.off(QnaScreen(lesson: lesson));
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: Icon(
                grammarTips.isNotEmpty &&
                        c.currentGrammerTipIndex.value == grammarTips.length - 1
                    ? Icons.quiz_rounded
                    : Icons.arrow_forward_rounded,
                size: 20,
              ),
              label: Text(
                grammarTips.isNotEmpty &&
                        c.currentGrammerTipIndex.value == grammarTips.length - 1
                    ? AppStrings.startQuiz.tr
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
    );
  }
}
