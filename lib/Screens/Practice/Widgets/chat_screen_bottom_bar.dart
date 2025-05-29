import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Controllers/practice_controller.dart';
import 'package:speak_ez/Screens/Practice/Widgets/doughnut_animation.dart';

class ChatScreenBottomBar extends StatelessWidget {
  const ChatScreenBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<PracticeController>();
    return Container(
      width: Get.width,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: const Color(0x33000000),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Obx(
            () =>
                c.isRecordingInProgress.value
                    ? IconButton(
                      onPressed: () {
                        c.stopRecording();
                      },
                      icon: Icon(Icons.close),
                      color: Colors.grey,
                    )
                    : SizedBox(),
          ),
          Obx(
            () =>
                c.isRecordingInProgress.value
                    ? AnimatedDoughnut()
                    : InkWell(
                      onTap: () => c.startRecording(),
                      child: SizedBox(
                        height: 100,
                        width: 100,
                        child: Icon(Icons.mic, size: 40, color: Colors.grey),
                      ),
                    ),
          ),
          Obx(
            () =>
                c.isRecordingInProgress.value
                    ? IconButton(
                      onPressed: () {
                        if (c.isRecordingPaused.value) {
                          c.startRecording();
                          c.lottieAnimationcontroller.repeat();
                          c.recordingAnimationcontroller.forward();
                        } else {
                          c.recordingAnimationcontroller.stop();
                          c.lottieAnimationcontroller.stop();
                          c.pauseRecording();
                        }
                      },
                      icon: Icon(
                        c.isRecordingPaused.value
                            ? Icons.play_arrow
                            : Icons.pause,
                      ),
                      color: Colors.grey,
                    )
                    : SizedBox(),
          ),
        ],
      ),
    );
  }
}
