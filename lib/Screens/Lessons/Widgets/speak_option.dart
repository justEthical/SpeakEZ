import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speak_ez/Controllers/question_options_controller.dart';
import 'package:speak_ez/Models/lesson_model.dart';
import 'package:speak_ez/Utils/flutter_stt_helper.dart';

class SpeakOption extends StatelessWidget {
  final Question question;
  const SpeakOption({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<QuestionOptionsController>();
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.deepPurple,
          borderRadius: BorderRadius.circular(100),
        ),
        child: IconButton(
          onPressed: () async {
            final micPermission = await Permission.microphone.request();
            if (micPermission.isGranted) {
              final stt = SpeechService();
              c.isListeningLessonAnswer.value = true;
              stt.startListening((result) {
                print(result);
                c.isListeningLessonAnswer.value = false;
              });
            }
          },
          icon: Obx(
            () =>
                c.isListeningLessonAnswer.value
                    ? Icon(Icons.speaker)
                    : Icon(Icons.mic, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
