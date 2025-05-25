import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Controllers/practice_controller.dart';
import 'package:speak_ez/Screens/Practice/Widgets/chat_bubble.dart';

import 'Widgets/doughnut_animation.dart';
import 'Widgets/progress_bar.dart';

class ChatScreen extends StatelessWidget {
  final String title;
  const ChatScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(PracticeController());
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                      fontFamily: AppStrings.nunitoFont,
                    ),
                  ),

                  Spacer(),
                  InkWell(
                    onTap: () => c.showExitBottomSheet(context),
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(Icons.close, color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ProgressBar(),
              SizedBox(height: 10),
              Expanded(
                child: Obx(
                  () => ListView.builder(
                    controller: c.chatScrollController,
                    itemCount: c.currentChats.length,
                    itemBuilder: (ctx, index) {
                      return ChatBubble(chatModel: c.currentChats[index]);
                    },
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
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
                                  child: Icon(
                                    Icons.mic,
                                    size: 40,
                                    color: Colors.grey,
                                  ),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
