import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Controllers/global_controller.dart';
import 'package:speak_ez/Models/lesson_model.dart';
import 'package:speak_ez/Models/user_profile.dart';
import 'package:speak_ez/Services/appwrite_service.dart';
import 'package:speak_ez/Services/firestore_helper.dart';

class HomeScreenController extends GetxController {
  var currenEnglishLessonLevel = "A1".obs;
  var currentLessonNameList = <Lesson>[].obs;

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  void calculateStreak() {
    final lastActive = globalController.userProfile.value.lastActive;
    final now = DateTime.now();
    if (DateTime(now.year, now.month, now.day)
            .difference(
              DateTime(lastActive.year, lastActive.month, lastActive.day),
            )
            .inDays >
        1) {
      globalController.userProfile.value.currentStreak = 0;
      // updating user profile in local storage
      globalController.prefs?.setString(
        AppStrings.userProfile,
        jsonEncode(globalController.userProfile.value.toMap()),
      );
      FirestoreHelper.updateUserField(
        globalController.userProfile.value.toMap(),
      );
    }
  }


  void fetchUserDetails() {
    var profileData = globalController.prefs?.getString(AppStrings.userProfile);
    globalController.userProfile.value = UserProfileModel.fromMap(
      jsonDecode(profileData!),
    );
    calculateStreak();
  }

  void fetchRemoteConfig() async {
    final config = await FirestoreHelper.fetchRemoteConfig();
    if (config != null) {
      globalController.remoteConfig = config;
      final storedConfig = globalController.prefs?.getString(
        AppStrings.remoteConfig,
      );

      for (final key in config.keys) {
        if (storedConfig == null ||
            config[key] != jsonDecode(storedConfig)[key]) {
          await AppwriteService().getLessons(
            fileName: "${key}_${config[key]}.zip",
          );
          await deleteFolderRecursively(
            "${globalController.appDocDirectoryPath}/lessons/$key",
          );
          await unzipFile(
            "${globalController.appDocDirectoryPath}/lessons/${key}_${config[key]}.zip",
            "${globalController.appDocDirectoryPath}/lessons/",
          );
          await renameDirectory(key: key, version: config[key]);
          await File(
            "${globalController.appDocDirectoryPath}/lessons/${key}_${config[key]}.zip",
          ).delete();
        }
      }

      globalController.prefs?.setString(
        AppStrings.remoteConfig,
        jsonEncode(config),
      );
    }
  }

  Future<void> deleteFolderRecursively(String folderPath) async {
    final dir = Directory(folderPath);

    if (await dir.exists()) {
      try {
        await dir.delete(recursive: true);
        print('Deleted folder: $folderPath');
      } catch (e) {
        print('Error deleting folder: $e');
      }
    } else {
      print('Folder does not exist: $folderPath');
    }
  }

  /// Unzips a zip file [zipFilePath] to the target [destinationDirectory]
  Future<void> unzipFile(
    String zipFilePath,
    String destinationDirectory,
  ) async {
    final zipFile = File(zipFilePath);

    if (!await zipFile.exists()) {
      print('Zip file not found: $zipFilePath');
      return;
    }

    try {
      // Read the zip file as bytes
      final bytes = await zipFile.readAsBytes();

      // Decode the bytes into an Archive
      final archive = ZipDecoder().decodeBytes(bytes);

      // For each file in the archive, write it to the destination
      for (final file in archive) {
        final filePath = '$destinationDirectory/${file.name}';

        if (file.isFile) {
          final outFile = File(filePath);
          await outFile.create(recursive: true);
          await outFile.writeAsBytes(file.content as List<int>);
        } else {
          final dir = Directory(filePath);
          await dir.create(recursive: true);
        }
      }

      print('Unzipped to $destinationDirectory');
    } catch (e) {
      print('Error unzipping file: $e');
    }
  }

  Future<void> renameDirectory({required String key, required String version})async{
    final dir = Directory("${globalController.appDocDirectoryPath}/lessons/${key}_$version");
    if (await dir.exists()) {
      await dir.rename("${globalController.appDocDirectoryPath}/lessons/$key");
    }
  }
}
