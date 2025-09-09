import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scroll_screenshot/scroll_screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Controllers/global_controller.dart';
import 'package:speak_ez/Models/ai_response_model.dart';
import 'package:speak_ez/Models/chat_model.dart';
import 'package:speak_ez/Models/evaluation_result.dart';
import 'package:speak_ez/Models/scenario_model.dart';
import 'package:speak_ez/Screens/Practice/Widgets/exit_alert_chat_bs.dart';
import 'package:speak_ez/Screens/Practice/chat_screen.dart';
import 'package:speak_ez/Services/network_service.dart';
import 'package:speak_ez/Utils/custom_dialogs.dart';
import 'package:speak_ez/Utils/tts_helper.dart';

import '../Utils/audio_chunk_recorder.dart';

class PracticeController extends GetxController {
  AudioChunkRecorder? recorder;

  var currentUserSessionMessage = 0.obs;
  var maxNumberOfAiResponsesPerSession = kDebugMode ? 5 : 10;
  final chatScrollController = ScrollController();
  var isRecordingInProgress = false.obs;
  var isRecordingPaused = false.obs;
  var remainingSeconds = 30.obs;
  var totalSpeakingTime = 0;
  late AnimationController recordingAnimationcontroller;
  late AnimationController lottieAnimationcontroller;
  FeedbackResult? resultModel;
  Timer? _timer;
  var currentChats = <ChatModel>[].obs;
  late Worker isLastChunkWorker;
  late StreamSubscription<bool> sub;

  ScenarioModel? currentScenarioModel;
  var isSpeaking = false.obs;
  var currentConversationSummary = "";
  List<AIResponseModel> aiResponseList = [];
  var isChatResultReady = false.obs;

  void startRecording() {
    recorder = AudioChunkRecorder();
    recorder?.startAutoRecording();
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
    isRecordingInProgress.value = true;
    isRecordingPaused.value = false;
    currentChats.add(
      ChatModel(
        message: "🎙️ Recording...",
        time: "time",
        isAI: false,
        messageDuration: 0,
        chatType: ChatType.normalChatMesssage,
      ),
    );
    _scrollToBottom();
  }

  void addChatCellTranscriptionData() {
    recorder?.stop();
    _timer?.cancel();
    isRecordingInProgress.value = false;
    currentChats.remove(currentChats.last);
    totalSpeakingTime += (30 - remainingSeconds.value);
    currentChats.add(
      ChatModel(
        message: "🎙️ Recording stopped",
        time: "time",
        isAI: false,
        messageDuration: 0,
        chatType: ChatType.transcribing, // transcribing animation
      ),
    );
    _scrollToBottom();
    print('listener hashcode: $hashCode');

    sub = globalController.isLastChunkTranscribed.listen((val) {
      print("Listener called: $val");
      if (val) {
        print("transcription done");
        // currentChats.remove(currentChats.last);
        globalController.transcriptionText.value = removeBracketedWords(
          globalController.transcriptionText.value,
        );
        // currentChats.add(
        //   ChatModel(
        //     message: globalController.transcriptionText.value,
        //     time: "time",
        //     isAI: false,
        //     messageDuration: 30 - remainingSeconds.value,
        //     chatType: ChatType.normalChatMesssage,
        //   ),
        // );
        // currentChats.add(
        //   ChatModel(
        //     message: "getting AI response",
        //     time: "time",
        //     isAI: true,
        //     messageDuration: 0,
        //     chatType: ChatType.gettingAIResponse,
        //   ),
        // );
        getAiResponse();
        // if (currentUserSessionMessage.value <=
        //     maxNumberOfAiResponsesPerSession) {
        //   getAiResponse();
        // }
        // if(currentUserSessionMessage.value >=
        //     maxNumberOfAiResponsesPerSession) {
        //   getConversationAiFeedbackResult();
        // }
        _scrollToBottom();
      }
      remainingSeconds.value = 30;
      sub.cancel();
      globalController.isLastChunkTranscribed.value = false;
    });
  }

  List getAverageScoreAndFeedback() {
    var fluency = 0;
    var grammar = 0;
    var vocabulary = 0;
    var pronunciation = 0;
    List<String> feedbackList = [];
    for (var i in aiResponseList) {
      fluency += i.scores.fluency;
      grammar += i.scores.grammar;
      vocabulary += i.scores.vocabulary;
      pronunciation += i.scores.pronunciation;
      feedbackList.add(i.feedback);
    }
    Map scoreMap = {
      "fluency": fluency / aiResponseList.length,
      "grammar": grammar / aiResponseList.length,
      "vocabulary": vocabulary / aiResponseList.length,
      "pronunciation": pronunciation / aiResponseList.length,
    };
    return [scoreMap, feedbackList];
  }

  Future<void> getConversationAiFeedbackResult() async {
    final [scoreMap, feedbackList] = getAverageScoreAndFeedback();

    final res = await NetworkService.getConversationAiFeedbackResult(
      scoreMap: scoreMap,
      feedbackList: feedbackList,
    );
    if (res != null) {
      resultModel = FeedbackResult.fromJson(
        jsonDecode(globalController.removeTicksJson(res)),
      );
      print(res);
      currentChats.remove(currentChats.last);
      isChatResultReady.value = true;
      addLastMessage();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (chatScrollController.hasClients) {
        chatScrollController.animateTo(
          chatScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
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

  String getLastAiMessage() {
    for (int i = currentChats.length - 1; i >= 0; i--) {
      if (currentChats[i].isAI) {
        return currentChats[i].message;
      }
    }
    return '';
  }

  Future<void> getAiResponse() async {
    final time = DateTime.now().millisecondsSinceEpoch;
    print("getting ai response");
    var response = await NetworkService.getAiResponse(
      userReply: globalController.transcriptionText.value,
      topic: currentScenarioModel!.prompt,
      lastAiMessage: getLastAiMessage(),
      summary: currentConversationSummary,
    );
    print(
      "got the ai response, time taook: ${DateTime.now().millisecondsSinceEpoch - time}",
    );
    if (response != null) {
      AIResponseModel aiResponse = AIResponseModel.fromJson(response);
      aiResponseList.add(aiResponse);
      currentUserSessionMessage.value++;
      currentConversationSummary = aiResponse.conversationSummary.trim();
      currentChats.remove(
        currentChats.last,
      ); // for removing transcribing(... animation) message
      currentChats.add(
        ChatModel(
          message:
              aiResponse.correctedTranscript
                  .trim(), // globalController.transcriptionText.value, //
          time: "time",
          isAI: false,
          messageDuration: 30 - remainingSeconds.value,
          chatType: ChatType.normalChatMesssage,
        ),
      );
      final isLastMessage =
          currentUserSessionMessage.value == maxNumberOfAiResponsesPerSession;
      if (isLastMessage) {
        currentChats.add(
          ChatModel(
            message: "getting AI response",
            time: "time",
            isAI: true,
            messageDuration: 0,
            chatType: ChatType.gettingAIResponse,
          ),
        );
        getConversationAiFeedbackResult();
      } else {
        currentChats.add(
          ChatModel(
            message: aiResponse.nextAiMessage.trim(),
            time: "time",
            isAI: true,
            messageDuration: 0,
            chatType: ChatType.normalChatMesssage,
          ),
        );
      }

      _scrollToBottom();
      isSpeaking.value = true;
      if (!isLastMessage) {
        await ttsHelper.speakAndWait(aiResponse.nextAiMessage.trim());
      }
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
        messageDuration: 0,
        chatType: ChatType.normalChatMesssage,
      ),
    );
    _scrollToBottom();
    Future.delayed(const Duration(seconds: 0), () async {
      isSpeaking.value = true;
      await ttsHelper.speakAndWait(currentScenarioModel!.intro);
      isSpeaking.value = false;
    });
  }

  void updatePracticeProgress() {
    final completedSessions =
        globalController.prefs?.getInt(AppStrings.completedPracticeSessions) ??
        0;
    globalController.prefs?.setInt(
      AppStrings.completedPracticeSessions,
      completedSessions + 1,
    );

    final lastActive = globalController.userProfile.value.lastActive;
    final now = DateTime.now();
    if (!(lastActive.year == now.year &&
        lastActive.month == now.month &&
        lastActive.day == now.day)) {
      globalController.userProfile.value.currentStreak++;
    }

    globalController.userProfile.value.lastActive = DateTime.now();

    globalController.updateProfile();
  }

  void addLastMessage() {
    currentChats.add(
      ChatModel(
        message: AppStrings.outroMessage,
        time: "time",
        isAI: true,
        messageDuration: 0,
        chatType: ChatType.normalChatMesssage,
      ),
    );
    _scrollToBottom();
    Future.delayed(const Duration(seconds: 0), () async {
      isSpeaking.value = true;
      await ttsHelper.speakAndWait(AppStrings.outroMessage);
      isSpeaking.value = false;
    });
  }

  void stopRecording() {
    recorder.stop();
    _timer?.cancel();
    isRecordingInProgress.value = false;
    isSpeaking.value = true; // just to disable mic button while transcribing
    currentChats.remove(currentChats.last);
    globalController.transcriptionText.value = "";
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
      final status = await Permission.microphone.request();
      if (status.isGranted) {
        Get.to(ChatScreen(scenarioModel: scenarioModel));
      }
    }
  }

  String formatDuration(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  String formatDateToLongString(DateTime date) {
    final weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    String getDaySuffix(int day) {
      if (day >= 11 && day <= 13) return 'th';
      switch (day % 10) {
        case 1:
          return 'st';
        case 2:
          return 'nd';
        case 3:
          return 'rd';
        default:
          return 'th';
      }
    }

    final dayOfWeek = weekdays[date.weekday - 1];
    final day = date.day;
    final suffix = getDaySuffix(day);
    final month = months[date.month - 1];
    final year = date.year;

    return '$dayOfWeek, $day$suffix $month $year';
  }

  Future<void> captureAndShare(globalKey) async {
    String? base64String = await ScrollScreenshot.captureAndSaveScreenshot(
      globalKey,
    );
    if (base64String == null) return;

    // Remove possible data URL prefix
    final base64Data = base64String.split(',').last;
    final bytes = base64Decode(base64Data);

    // Save image to temp directory
    final tempDir = await getTemporaryDirectory();
    final file = await File('${tempDir.path}/screenshot.png').create();
    await file.writeAsBytes(bytes);

    // Share image using share_plus
    await SharePlus.instance.share(
      ShareParams(
        text: "Checkout my result on SpeakEZ AI",
        files: [XFile(file.path)],
      ),
    );
  }

  int getOverAllScore(FeedbackResult result) {
    double overAllScore = 0;
    final [scoreMap, feedbackList] = getAverageScoreAndFeedback();
    overAllScore += scoreMap['fluency'];
    overAllScore += scoreMap['grammar'];
    overAllScore += scoreMap['vocabulary'];
    overAllScore += scoreMap['pronunciation'];
    overAllScore = (overAllScore / 4) * 10;
    return overAllScore.toInt();
  }
}
