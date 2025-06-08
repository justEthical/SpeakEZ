import 'dart:async';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Controllers/global_controller.dart';
import 'package:speak_ez/Models/chat_model.dart';
import 'package:speak_ez/Screens/Practice/Widgets/exit_alert_chat_bs.dart';
import 'package:speak_ez/Screens/Practice/chat_screen.dart';
import 'package:speak_ez/Services/network_service.dart';
import 'package:speak_ez/Utils/custom_dialogs.dart';
import 'package:speak_ez/Utils/tts_helper.dart';
import 'package:speak_ez/Utils/whisper_helper.dart';

import '../Utils/audio_chunk_recorder.dart';

class PracticeController extends GetxController {
  final AudioChunkRecorder recorder = AudioChunkRecorder();
  var transcriptionText = "".obs;
  var currentUserSessionMessage = 0.obs;
  final chatScrollController = ScrollController();
  var isRecordingInProgress = false.obs;
  var isRecordingPaused = false.obs;
  var remainingSeconds = 30.obs;
  late AnimationController recordingAnimationcontroller;
  late AnimationController lottieAnimationcontroller;
  Timer? _timer;
  var currentChats = <ChatModel>[].obs;
  var isLastChunkTranscribed = false.obs;
  late Worker isLastChunkWorker;
  late StreamSubscription<bool> sub;
  late SendPort whisperSendPort;
  var isWhisperInitialized = false.obs;
  final tts = TextToSpeechService();
  var isSpeaking = false.obs;

  Future<void> startWhisperIsolate() async {
    final ReceivePort onMainReceive = ReceivePort();

    final RootIsolateToken token = RootIsolateToken.instance!;
    await Isolate.spawn(WhisperHelper.whisperIsolateEntry, [
      onMainReceive.sendPort,
      globalController.appDocDirectoryPath,
      token,
    ]);

    whisperSendPort = await onMainReceive.first;
    isWhisperInitialized.value = true;
    print('Whisper isolate started $whisperSendPort');
  }

  void startRecording() {
    _addRecordingChatCell();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value == 0) {
        print("Timer stopped");
        addChatCellTranscriptionData();
      } else {
        // print("Timmer running ${remainingSeconds.value}");
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
        message: "🎙️ Recording...",
        time: "time",
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

  void addChatCellTranscriptionData() {
    recorder.stop();
    _timer?.cancel();
    isRecordingInProgress.value = false;
    currentChats.remove(currentChats.last);
    remainingSeconds.value = 30;

    currentChats.add(
      ChatModel(
        message: "🎙️ Recording stopped",
        time: "time",
        isAI: false,
        chatType: ChatType.transcribing,
      ),
    );
    chatScrollController.animateTo(
      chatScrollController.position.maxScrollExtent * 2,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
    print('listener hashcode: $hashCode');

    sub = isLastChunkTranscribed.listen((val) {
      print("Listener called: $val");
      if (val) {
        currentChats.remove(currentChats.last);
        transcriptionText.value = removeBracketedWords(transcriptionText.value);
        currentChats.add(
          ChatModel(
            message: transcriptionText.value,
            time: "time",
            isAI: false,
            chatType: ChatType.normalChatMesssage,
          ),
        );
        currentChats.add(
          ChatModel(
            message: transcriptionText.value,
            time: "time",
            isAI: true,
            chatType: ChatType.gettingAIResponse,
          ),
        );
        getAiResponse();
        chatScrollController.animateTo(
          chatScrollController.position.maxScrollExtent * 2,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
      sub.cancel();
      isLastChunkTranscribed.value = false;
    });
  }

  String removeBracketedWords(String text) {
    // Matches any word starting with [ or (, up to the next space, or closed bracket/parenthesis (greedy).
    final pattern = RegExp(
      r'(\s*[\[\(][^\s\]\)]*[\]\)]?\s*)',
      caseSensitive: false,
    );
    String cleaned = text.replaceAll(pattern, ' ');
    // Remove any extra spaces
    return cleaned.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  List<Map<String, String>> getPastConversation() {
    List<Map<String, String>> pastConversation = [];
    for (var chat in currentChats) {
      if (chat.chatType == ChatType.normalChatMesssage) {
        pastConversation.add({(chat.isAI ? "You" : "User"): chat.message});
      }
    }
    return pastConversation;
  }

  getAiResponse() async {
    var response = await NetworkService.getAiReposne(
      transcriptionText.value,
      topic: "Job interview",
      pastConversation: getPastConversation(),
    );
    if (response != null) {
      currentUserSessionMessage.value++;
      currentChats.remove(currentChats.last);
      currentChats.add(
        ChatModel(
          message: response.trim(),
          time: "time",
          isAI: true,
          chatType: ChatType.normalChatMesssage,
        ),
      );

      chatScrollController.animateTo(
        chatScrollController.position.maxScrollExtent * 2,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
      isSpeaking.value = true;
      await tts.speakAndWait(response);
      isSpeaking.value = false;
    }
  }

  addInitialMessage() {
    currentChats.add(
      ChatModel(
        message: AppStrings.initialMessage,
        time: "time",
        isAI: true,
        chatType: ChatType.normalChatMesssage,
      ),
    );
    chatScrollController.animateTo(
      chatScrollController.position.maxScrollExtent + 20,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
    Future.delayed(const Duration(seconds: 2), () async {
      isSpeaking.value = true;
      await tts.speakAndWait(AppStrings.initialMessage);
      isSpeaking.value = false;
    });
  }

  void stopRecording() {
    recorder.stop();
    _timer?.cancel();
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

  void getMicrophonePermission(String title) async {
    final status = await Permission.microphone.status;
    if (status.isGranted) {
      Get.to(ChatScreen(title: title));
    } else if (status.isPermanentlyDenied) {
      Get.defaultDialog(
        titleStyle: const TextStyle(fontSize: 0),
        content: CustomDialogs.enableMicrophonePermissionFromSettings(),
      );
    } else {
      await Permission.microphone.request();
      getMicrophonePermission(title);
    }
  }
}
