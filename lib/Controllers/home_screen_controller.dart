import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Controllers/global_controller.dart';
import 'package:speak_ez/Models/lesson_model.dart';
import 'package:speak_ez/Models/user_profile.dart';
import 'package:speak_ez/Services/firestore_helper.dart';
import 'package:speak_ez/Services/posthog_service.dart';

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
    // reset weekDaysStreak if it's the first app open of the new week
    updateWeekDaysStreak(); 
  }

  void updateWeekDaysStreak() {
    final now = DateTime.now();
    final lastActive = globalController.userProfile.value.lastActive;

    // Calculate the start of the current week (Monday at 00:00:00)
    // weekday: Monday = 1, Sunday = 7
    // Subtracting (weekday - 1) days from today gives us this week's Monday
    final startOfCurrentWeek = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: now.weekday - 1));

    final lastActiveDate = DateTime(lastActive.year, lastActive.month, lastActive.day);

    // If lastActive is before this week's Monday, reset the weekly streak
    // This handles: user opens app on Tuesday (or any day) for the first time this week
    if (lastActiveDate.isBefore(startOfCurrentWeek)) {
      globalController.userProfile.value.weekDaysStreak = WeekDaysStreak.fromMap({});
      globalController.prefs?.setString(
        AppStrings.userProfile,
        jsonEncode(globalController.userProfile.value.toMap()),
      );
      FirestoreHelper.updateUserField(
        globalController.userProfile.value.toMap(),
      );
    }
  }

  Future<void> deleteFolderRecursively(String folderPath) async {
    final dir = Directory(folderPath);

    if (await dir.exists()) {
      try {
        await dir.delete(recursive: true);
        debugPrint('Deleted folder: $folderPath');
      } catch (e) {
        PostHogService.instance.captureError(
          'file_system_error',
          errorMessage: 'Error deleting folder: $e',
          location: 'HomeScreenController.deleteFolder',
          additionalProperties: {'folder_path': folderPath},
        );
        debugPrint('Error deleting folder: $e');
      }
    } else {
      debugPrint('Folder does not exist: $folderPath');
    }
  }

  /// Unzips a zip file [zipFilePath] to the target [destinationDirectory]
  Future<void> unzipFile(
    String zipFilePath,
    String destinationDirectory,
  ) async {
    final zipFile = File(zipFilePath);

    if (!await zipFile.exists()) {
      debugPrint('Zip file not found: $zipFilePath');
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

      debugPrint('Unzipped to $destinationDirectory');
    } catch (e) {
      PostHogService.instance.captureError(
        'file_system_error',
        errorMessage: 'Error unzipping file: $e',
        location: 'HomeScreenController.unzipFile',
        additionalProperties: {
          'source_file': zipFilePath,
          'destination': destinationDirectory,
        },
      );
      debugPrint('Error unzipping file: $e');
    }
  }

  Future<void> renameDirectory({required String key, required String version})async{
    final dir = Directory("${globalController.appDocDirectoryPath}/lessons/${key}_$version");
    if (await dir.exists()) {
      await dir.rename("${globalController.appDocDirectoryPath}/lessons/$key");
    }
  }
}
