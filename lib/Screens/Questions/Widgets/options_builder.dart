import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Controllers/question_options_controller.dart';

class OptionsBuilder extends StatelessWidget {
  final options;
  const OptionsBuilder({super.key, required this.options});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<QuestionOptionsController>();
    print("c.currentQuestionIndex.value: ${c.currentQuestionIndex.value}");
    return Column(
      children: [
        ...List.generate(
          options.length,
          (index) => InkWell(
            onTap: () => c.currentSelectedOptionIndex.value = index,
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
