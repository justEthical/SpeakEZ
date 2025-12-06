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
import 'package:speak_ez/Services/admob_service.dart';
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
  set isSpeaking(bool value) {
    if (globalController.isDeepInfraTranscription.value) {
      isMicEnabled.value = !value;
    } else {
      isMicEnabled.value =
          (!value && globalController.isWhisperInitialized.value);
    }
  }

  set isAudioProcessing(bool value) {
    isMicEnabled.value = !value;
  }

  var currentConversationSummary = "";
  List<AIResponseModel> aiResponseList = [];
  var isChatResultReady = false.obs;

  var isMicEnabled = false.obs;

  void startRecording() {
    recorder = AudioChunkRecorder();
    _addRecordingChatCell();
    if (globalController.isDeepInfraTranscription.value) {
      recorder?.startRecording(); // normal full 30 second recording
    } else {
      recorder?.startAutoRecording(); // auto recording with chunks on pauses
    }
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value == 0) {
        print("Timer stopped");
        endRecording();
      } else {
        remainingSeconds.value--;
      }
    });
  }

  void endRecording() {
    isRecordingInProgress.value = false;
    if (globalController.isDeepInfraTranscription.value) {
      stopNormalRecording();
    } else {
      recorder?.stop();
      addChatCellTranscriptionData();
    }
  }

  void stopNormalRecording() {
    _removeRecordingChat();
    isAudioProcessing = true;
    recorder?.stopRecording().then((value) {
      addChatCellTranscriptionData();
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

  _removeRecordingChat() {
    currentChats.remove(currentChats.last);
    currentChats.add(
      ChatModel(
        message: "🎙️ Recording stopped",
        time: "time",
        isAI: false,
        messageDuration: 0,
        chatType: ChatType.transcribing, // transcribing animation
      ),
    );
  }

  Future<void> addChatCellTranscriptionData() async {
    _timer?.cancel();
    isRecordingInProgress.value = false;

    totalSpeakingTime += (30 - remainingSeconds.value);
    _scrollToBottom();
    print('listener hashcode: $hashCode');

    if (globalController.isDeepInfraTranscription.value) {
      globalController.transcriptionText.value = removeBracketedWords(
        globalController.transcriptionText.value,
      );
      await getAiResponse();
      _scrollToBottom();
      remainingSeconds.value = 30;
    } else {
      _removeRecordingChat(); // remove recording chat message and add transcribing animation
      sub = globalController.isLastChunkTranscribed.listen((val) {
        print("Listener called: $val");
        if (val) {
          print("transcription done");
          // currentChats.remove(currentChats.last);
          globalController.transcriptionText.value = removeBracketedWords(
            globalController.transcriptionText.value,
          );

          getAiResponse();

          _scrollToBottom();
        }
        remainingSeconds.value = 30;
        sub.cancel();
        globalController.isLastChunkTranscribed.value = false;
      });
    }
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
        jsonDecode(globalController.removeTickMarksJson(res)),
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
        await getConversationAiFeedbackResult();
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
      isSpeaking = true;
      if (!isLastMessage) {
        await ttsHelper.speakAndWait(aiResponse.nextAiMessage.trim());
      }
      isSpeaking = false; // just to disable mic button while transcribing
    }

    isAudioProcessing = false;
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
      isSpeaking = true;
      await ttsHelper.speakAndWait(currentScenarioModel!.intro);
      isSpeaking = false;
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

  void showInterstitialAd() {
    final difference =
        DateTime.now()
            .difference(globalController.userProfile.value.registrationTime)
            .inDays;
    if (difference > 2) {
      GoogleMobileAdsService.instance.showInterstitial();
    }
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
      isSpeaking = true;
      await ttsHelper.speakAndWait(AppStrings.outroMessage);
      isSpeaking = false;
    });
  }

  void stopRecording() {
    recorder?.stop();
    _timer?.cancel();
    isRecordingInProgress.value = false;
    isSpeaking = true; // just to disable mic button while transcribing
    currentChats.remove(currentChats.last);
    globalController.transcriptionText.value = "";
    remainingSeconds.value = 30;
  }

  void pauseRecording() {
    recorder?.stop();
    _timer!.cancel();
    currentChats.remove(currentChats.last);
    isRecordingPaused.value = true;
  }

  bool isBottomSheetOpen = false;
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

  Future<bool> getMicrophonePermission(ScenarioModel scenarioModel) async {
    final status = await Permission.microphone.status;
    if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied) {
      Get.defaultDialog(
        titleStyle: const TextStyle(fontSize: 0),
        content: CustomDialogs.enablePermissionFromSettings(
          Get.context!,
          'Please enable microphone permission from settings.',
        ),
      );
    } else {
      final status = await Permission.microphone.request();
      if (status.isGranted) {
        return true;
      }
    }
    return false;
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
