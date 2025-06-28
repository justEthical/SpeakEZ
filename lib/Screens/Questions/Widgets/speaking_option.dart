import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Controllers/question_options_controller.dart';

class SpeakingOption extends StatelessWidget {
  const SpeakingOption({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<QuestionOptionsController>();
    c.isMicOn.value = false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Obx(
          () => Text(
            c.currenSpeakingText.value,
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
        ),
        SizedBox(height: 20),
        Obx(
          () => InkWell(
            onTap: () {
              c.isMicOn.value = !c.isMicOn.value;
            },
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x33000000),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),

              child: Icon(
                Icons.mic,
                size: 30,
                color: c.isMicOn.value ? Colors.deepPurple : Colors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
