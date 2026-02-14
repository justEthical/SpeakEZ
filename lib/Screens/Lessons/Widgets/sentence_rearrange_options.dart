import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Controllers/question_options_controller.dart';
import 'package:speak_ez/Models/lesson_model.dart';
import 'package:speak_ez/Utils/tts_helper.dart';

class SentenceRearrangeOptions extends StatefulWidget {
  final Question question;
  const SentenceRearrangeOptions({super.key, required this.question});

  @override
  State<SentenceRearrangeOptions> createState() =>
      _SentenceRearrangeOptionsState();
}

class _SentenceRearrangeOptionsState extends State<SentenceRearrangeOptions> {
  final c = Get.find<QuestionOptionsController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      c.sentenceRearrangeOptionList.clear();
      c.sentenceRearrangeTempList.clear();
      c.sentenceRearrangeOptionList.addAll(
        List.generate(
          widget.question.options!.length,
          (i) => widget.question.options![i].toString(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Selected words area (answer area)
        Obx(
          () => AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: Get.width - 32,
            constraints: const BoxConstraints(minHeight: 80),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: c.sentenceRearrangeTempList.isEmpty
                  ? null
                  : LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
                        Theme.of(context).colorScheme.primary.withValues(alpha: 0.03),
                      ],
                    ),
              color: c.sentenceRearrangeTempList.isEmpty
                  ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.03)
                  : null,
              border: Border.all(
                color: c.sentenceRearrangeTempList.isEmpty
                    ? Colors.grey.withValues(alpha: 0.3)
                    : Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                width: c.sentenceRearrangeTempList.isEmpty ? 1 : 2,
                strokeAlign: BorderSide.strokeAlignCenter,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: c.sentenceRearrangeTempList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.touch_app_rounded,
                          color: Colors.grey.shade400,
                          size: 28,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Tap words below to form a sentence",
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 13,
                            fontFamily: AppStrings.poppinsFont,
                          ),
                        ),
                      ],
                    ),
                  )
                : Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(
                      c.sentenceRearrangeTempList.length,
                      (index) {
                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              c.sentenceRearrangeOptionList.add(
                                c.sentenceRearrangeTempList[index],
                              );
                              c.sentenceRearrangeTempList.removeAt(index);
                            },
                            borderRadius: BorderRadius.circular(10),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Theme.of(context).colorScheme.primary,
                                    Theme.of(context).colorScheme.primary.withValues(alpha: 0.85),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.25),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Text(
                                c.sentenceRearrangeTempList[index],
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: AppStrings.poppinsFont,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 20),

        // Available words area
        Obx(
          () => Wrap(
            spacing: 8,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: List.generate(c.sentenceRearrangeOptionList.length, (index) {
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    ttsHelper.speak(c.sentenceRearrangeOptionList[index]);
                    c.sentenceRearrangeTempList.add(
                      c.sentenceRearrangeOptionList[index],
                    );
                    c.sentenceRearrangeOptionList.removeAt(index);
                    c.shouldEnableContinueButton(widget.question.type);
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.grey.withValues(alpha: 0.3),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          c.sentenceRearrangeOptionList[index],
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: AppStrings.poppinsFont,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(
                          Icons.add_rounded,
                          size: 18,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
