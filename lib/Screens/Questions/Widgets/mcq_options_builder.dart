import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Controllers/question_options_controller.dart';
import 'package:speak_ez/Models/questions_model.dart';
import 'package:speak_ez/Utils/tts_helper.dart';

class MCQOptionsBuilder extends StatelessWidget {
  final options;
  final QuestionType questionType;
  const MCQOptionsBuilder({
    super.key,
    required this.options,
    required this.questionType,
  });

  @override
  Widget build(BuildContext context) {
    final c = Get.find<QuestionOptionsController>();
    return Column(
      children: [
        ...List.generate(
          options.length,
          (index) => InkWell(
            onTap: () {
              final tts = TextToSpeechService();
              tts.speak(options[index]);
              c.currentSelectedOptionIndex.value = index;
              c.shouldEnableContinueButton(questionType);
            },
            child: Obx(
              () => Container(
                width: Get.width,
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color:
                      index == c.currentSelectedOptionIndex.value
                          ? Colors.purple
                          : const Color(0xFFF2F2F2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    options[index],
                    style: TextStyle(
                      fontSize: 15,
                      color:
                          index == c.currentSelectedOptionIndex.value
                              ? Colors.white
                              : Colors.black87,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
