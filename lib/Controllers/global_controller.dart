import 'dart:convert';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Models/user_profile.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speak_ez/Services/firestore_helper.dart';
import 'package:speak_ez/Utils/custom_dialogs.dart';
import 'package:speak_ez/Utils/whisper_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class GlobalController extends GetxController {
  static GlobalController instance = Get.find();
  SharedPreferences? prefs;
  late SendPort whisperSendPort; // send port to whisper isolate
  var isWhisperInitialized = false.obs;
  var transcriptionText = "".obs;
  var isLastChunkTranscribed = false.obs;

  var userProfile = UserProfileModel.fromMap({}).obs;
  final cutomTabBarController = PageController(initialPage: 0);
  String appDocDirectoryPath = "";

  var appVersion = "".obs;

  var currentTabIndex = 0.obs;

  var transcription = "".obs;

  var aiModelDownloadProgress = 0.0.obs;
  var isAiModelDownloaded = false.obs;
  final currentLessonsVersion = "1.0.0";
  var remoteConfig = {};

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    loadVersion();
    getAppDocDirectoryPath();
  }

  

  Future<void> startWhisperIsolate() async {
    if (isWhisperInitialized.value) {
      print("Whisper already initialized");
      whisperSendPort.send('stop');
    } else if(isAiModelDownloaded.value) {
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
  }

  Future<void> getAppDocDirectoryPath() async {
    final dir = await getApplicationDocumentsDirectory();
    appDocDirectoryPath = dir.path;
  }

  void loadVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appVersion.value = "${packageInfo.version}(${packageInfo.buildNumber})";
  }

  Future<LottieComposition?> customDecoder(List<int> bytes) {
    return LottieComposition.decodeZip(
      bytes,
      filePicker: (files) {
        return files.firstWhereOrNull(
          (f) => f.name.startsWith('animations/') && f.name.endsWith('.json'),
        );
      },
    );
  }

  void openAppSetting() async {
    bool opened = await openAppSettings();
    if (!opened) {
      // handle failure to open settings
      print('Could not open settings');
    }
  }

  void askNotificationPermission() async {
    final status = await Permission.notification.status;
    if (!status.isGranted) {
      if (status.isPermanentlyDenied) {
        Get.defaultDialog(
        titleStyle: const TextStyle(fontSize: 0),
        content: CustomDialogs.enablePermissionFromSettings(
          Get.context!,
          'Please enable notification permission from settings to keep updated.',
        ),
      );
      }
      await Permission.notification.request();
    }
  }

  void showSnackbarWithGetX(String title, String message) {
    Future.delayed(
      Duration(microseconds: 100),
      () => Get.snackbar(
        title,
        message,
        backgroundColor: Colors.black,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      ),
    );
  }

void updateProfile()async{
  
  // updating user profile in local storage
  globalController.prefs?.setString(
    AppStrings.userProfile,
    jsonEncode(userProfile.value.toMap()),
  );
  // updating user profile in firestore
  FirestoreHelper.updateUserField(userProfile.value.toMap()); 
}
  Future<void> openUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  String removeTicksJson(String text) {
    if(text.startsWith('```') && text.endsWith('```')) { 
      text = text.replaceAll('json', '');
      text = text.replaceAll('```', '');
      text = text.trim();
      return text;
    } else {
      return text;
    }
  }
}

GlobalController globalController = GlobalController.instance;
