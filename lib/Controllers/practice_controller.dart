import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Models/chat_model.dart';
import 'package:speak_ez/Screens/Practice/Widgets/exit_alert_chat_bs.dart';

import '../Utils/audio_chunk_recorder.dart';

class PracticeController extends GetxController {
  final AudioChunkRecorder recorder = AudioChunkRecorder();
  var transcriptionText = "".obs;
  var currentUserSessionSeconds = 0.obs;
  final chatScrollController = ScrollController();
  var isRecordingInProgress = false.obs;
  var isRecordingPaused = false.obs;
  var remainingSeconds = 30.obs;
  late AnimationController recordingAnimationcontroller;
  late AnimationController lottieAnimationcontroller;
  Timer? _timer;
  var currentChats = <ChatModel>[].obs;

  void startRecording() {
    _addRecordingChatCell();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value == 0) {
        print("Timer stopped");
        _addChatCellTranscriptionData(timer);
      } else {
        print("Timmer running ${remainingSeconds.value}");
        remainingSeconds.value--;
      }
    });
  }

  _addRecordingChatCell() {
    recorder.startAutoRecording();
    isRecordingInProgress.value = true;
    isRecordingPaused.value = false;
    currentChats.add(
      ChatModel(
        message: "",
        time: "time",
        isAI: false,
        chatType: ChatType.transcribing,
      ),
    );
    chatScrollController.animateTo(
      chatScrollController.position.maxScrollExtent + 20,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  _addChatCellTranscriptionData(Timer timer) {
    recorder.stop();
    timer.cancel();
    isRecordingInProgress.value = false;
    currentChats.remove(currentChats.last);
    transcriptionText.value = "";
    remainingSeconds.value = 30;
    currentChats.add(
      ChatModel(
        message: transcriptionText.value,
        time: "${DateTime.now().hour}:${DateTime.now().minute}",
        isAI: false,
        chatType: ChatType.normalChatMesssage,
      ),
    );
    chatScrollController.animateTo(
      chatScrollController.position.maxScrollExtent + 20,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void stopRecording() {
    recorder.stop();
    _timer!.cancel();
    isRecordingInProgress.value = false;
    currentChats.remove(currentChats.last);
    transcriptionText.value = "";
    remainingSeconds.value = 30;
  }

  void pauseRecording() {
    recorder.stop();
    _timer!.cancel();
    currentChats.remove(currentChats.last);
    isRecordingPaused.value = true;
  }

  void showExitBottomSheet(context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      isScrollControlled: true,
      builder: (context) => ExitAlertChatBottomSheet(),
    );
  }
}
