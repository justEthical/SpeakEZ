import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    // TODO: implement initState
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
        Obx(
          () => Container(
            width: Get.width - 20,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color:
                  c.sentenceRearrangeTempList.isEmpty
                      ? Colors.transparent
                      : Colors.grey[200],
              border: Border.all(
                color:
                    c.sentenceRearrangeTempList.isEmpty
                        ? Colors.transparent
                        : Colors.black26,
                width: 0.4,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child:
                c.sentenceRearrangeTempList.isEmpty
                    ? SizedBox()
                    : Wrap(
                      children: List.generate(
                        c.sentenceRearrangeTempList.length,
                        (index) {
                          return InkWell(
                            onTap: () {
                              c.sentenceRearrangeOptionList.add(
                                c.sentenceRearrangeTempList[index],
                              );
                              c.sentenceRearrangeTempList.removeAt(index);
                            },
                            child: Container(
                              margin: const EdgeInsets.all(5),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.deepPurple,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                "${c.sentenceRearrangeTempList[index]} ",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
          ),
        ),
        SizedBox(height: 15),
        Obx(
          () => Wrap(
            children: List.generate(c.sentenceRearrangeOptionList.length, (
              index,
            ) {
              return InkWell(
                onTap: () {
                  
                  ttsHelper.speak(c.sentenceRearrangeOptionList[index]);
                  c.sentenceRearrangeTempList.add(
                    c.sentenceRearrangeOptionList[index],
                  );
                  c.sentenceRearrangeOptionList.removeAt(index);
                  c.shouldEnableContinueButton(widget.question.type);
                },
                child: Container(
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    "${c.sentenceRearrangeOptionList[index]} ",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
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
