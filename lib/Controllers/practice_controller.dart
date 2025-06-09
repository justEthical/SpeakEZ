import 'dart:async';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Controllers/global_controller.dart';
import 'package:speak_ez/Models/chat_model.dart';
import 'package:speak_ez/Models/scenario_model.dart';
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
  var maxNumberOfAiResponsesPerSession = 5;
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
  ScenarioModel? currentScenarioModel;
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
    _scrollToBottom();
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
    _scrollToBottom();
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
        currentUserSessionMessage.value++;
        if (currentUserSessionMessage.value <
            maxNumberOfAiResponsesPerSession) {
          currentChats.add(
            ChatModel(
              message: "getting AI response",
              time: "time",
              isAI: true,
              chatType: ChatType.gettingAIResponse,
            ),
          );
          getAiResponse();
          _scrollToBottom();
        } else {
          
          addLastMessage();
        }
      }
      sub.cancel();
      isLastChunkTranscribed.value = false;
    });
  }

  void _scrollToBottom() {
    chatScrollController.animateTo(
      chatScrollController.position.maxScrollExtent * 2,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
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
      topic: currentScenarioModel!.prompt,
      pastConversation: getPastConversation(),
    );
    if (response != null) {
      currentChats.remove(currentChats.last);
      currentChats.add(
        ChatModel(
          message: response.trim(),
          time: "time",
          isAI: true,
          chatType: ChatType.normalChatMesssage,
        ),
      );

      _scrollToBottom();
      isSpeaking.value = true;
      await tts.speakAndWait(response);
      isSpeaking.value = false;
    }
  }

  void addInitialMessage() {
    currentChats.clear();
    currentChats.add(
      ChatModel(
        message: currentScenarioModel!.intro,
        time: "time",
        isAI: true,
        chatType: ChatType.normalChatMesssage,
      ),
    );
    _scrollToBottom();
    Future.delayed(const Duration(seconds: 0), () async {
      isSpeaking.value = true;
      await tts.speakAndWait(currentScenarioModel!.intro);
      isSpeaking.value = false;
    });
  }

  void addLastMessage() {
    currentChats.add(
      ChatModel(
        message: AppStrings.outroMessage,
        time: "time",
        isAI: true,
        chatType: ChatType.normalChatMesssage,
      ),
    );
    _scrollToBottom();
    Future.delayed(const Duration(seconds: 0), () async {
      isSpeaking.value = true;
      await tts.speakAndWait(AppStrings.outroMessage);
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

  void getMicrophonePermission(ScenarioModel scenarioModel) async {
    final status = await Permission.microphone.status;
    if (status.isGranted) {
      Get.to(ChatScreen(scenarioModel: scenarioModel));
    } else if (status.isPermanentlyDenied) {
      Get.defaultDialog(
        titleStyle: const TextStyle(fontSize: 0),
        content: CustomDialogs.enableMicrophonePermissionFromSettings(),
      );
    } else {
      final  status = await Permission.microphone.request();
      if(status.isGranted){
        Get.to(ChatScreen(scenarioModel: scenarioModel));
      }
    }
  }
}
