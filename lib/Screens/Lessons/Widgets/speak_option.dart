import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speak_ez/Controllers/question_options_controller.dart';
import 'package:speak_ez/Models/lesson_model.dart';
import 'package:speak_ez/Utils/flutter_stt_helper.dart';

class SpeakOption extends StatefulWidget {
  final Question question;
  const SpeakOption({super.key, required this.question});

  @override
  State<SpeakOption> createState() => _SpeakOptionState();
}

class _SpeakOptionState extends State<SpeakOption> {
  final c = Get.find<QuestionOptionsController>();

  final stt = SpeechService();

  @override
  void initState() {
    super.initState();
    c.speakingQuestionAccuracy = 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Obx(
        () =>
            c.isListeningLessonAnswer.value
                ? Column(
                  children: [
                    c.isListeningLessonAnswer.value ? Text(
                      "Tap to stop",
                      style: TextStyle(
                        color: Colors.deepPurple,
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w600,
                      ),
                    ) : SizedBox(),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: () {
                        c.stopRecording();
                        c.isListeningLessonAnswer.value =
                            !c.isListeningLessonAnswer.value;
                      },
                      child: Container(
                        width: 60,
                        height: 60,
                        padding: const EdgeInsets.all(18.0),
                        decoration: BoxDecoration(
                          color:
                              c.isListeningLessonAnswer.value
                                  ? Colors.grey.shade200
                                  : Colors.deepPurple,
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            color: Colors.deepPurple,
                            width: 0.4,
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      c.isAudioProcessing.value
                          ? "Processing..."
                          : "Listening...",
                      style: TextStyle(
                        color: Colors.deepPurple,
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                )
                : Container(
                  decoration: BoxDecoration(
                    color:
                        c.isListeningLessonAnswer.value
                            ? Colors.white
                            : Colors.deepPurple,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: IconButton(
                    onPressed: () async {
                      final micPermission =
                          await Permission.microphone.request();
                      if (micPermission.isGranted) {
                        c.startRecording();
                      }
                    },
                    icon: Icon(Icons.mic, color: Colors.white, size: 40),
                  ),
                ),
      ),
    );
  }
}
