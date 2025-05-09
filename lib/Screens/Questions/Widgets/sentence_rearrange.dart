import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Controllers/question_options_controller.dart';
import 'package:speak_ez/Models/questions_model.dart';
import 'package:speak_ez/Utils/tts_helper.dart';

class SentenceRearrange extends StatefulWidget {
  final List<dynamic> options;
  final QuestionType questionType;
  const SentenceRearrange({
    super.key,
    required this.options,
    required this.questionType,
  });

  @override
  State<SentenceRearrange> createState() => _SentenceRearrangeState();
}

class _SentenceRearrangeState extends State<SentenceRearrange> {
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
          widget.options.length,
          (i) => widget.options[i].toString(),
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
              border: Border.all(
                color:
                    c.sentenceRearrangeTempList.isEmpty
                        ? Colors.transparent
                        : Colors.black26,
                width: 1,
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
                                color: Colors.purple,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                "${c.sentenceRearrangeTempList[index]} ",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
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
                  
                  final tts = TextToSpeechService();
                  tts.speak(c.sentenceRearrangeOptionList[index]);
                  c.sentenceRearrangeTempList.add(
                    c.sentenceRearrangeOptionList[index],
                  );
                  c.sentenceRearrangeOptionList.removeAt(index);
                  c.shouldEnableContinueButton(widget.questionType);
                },
                child: Container(
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "${c.sentenceRearrangeOptionList[index]} ",
                    style: TextStyle(fontSize: 15, color: Colors.white),
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
