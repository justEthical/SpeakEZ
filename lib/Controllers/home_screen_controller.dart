import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Controllers/global_controller.dart';
import 'package:speak_ez/Models/lesson_model.dart';
import 'package:speak_ez/Models/user_profile_model.dart';

class HomeScreenController extends GetxController {
  var currenEnglishLessonLevel = "A1".obs;
  var currentLessonNameList = <LessonModel>[].obs;

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    changeEnglishLevel('A1');
  }

  void changeEnglishLevel(String level) async {
    switch (level) {
      case "A1":
        currenEnglishLessonLevel.value = "A1";
        loadLessonsFromJson('assets/lessons/a1.json');
        break;
      case "A2":
        currenEnglishLessonLevel.value = "A2";
        loadLessonsFromJson('assets/lessons/a2.json');
        break;
      case "B1":
        currenEnglishLessonLevel.value = "B1";
        loadLessonsFromJson('assets/lessons/a2.json');
        break;
      case "B2":
        currenEnglishLessonLevel.value = "B2";
        loadLessonsFromJson('assets/lessons/a2.json');
        break;
      case "C1":
        currenEnglishLessonLevel.value = "C1";
        loadLessonsFromJson('assets/lessons/a2.json');
        break;
      case "C2":
        currenEnglishLessonLevel.value = "C2";
        loadLessonsFromJson('assets/lessons/a2.json');
        break;
    }
    currenEnglishLessonLevel.value = level;
  }

  void loadLessonsFromJson(String path) async {
    final content = await rootBundle.loadString(path);
        final jsonString = jsonDecode(content.toString());
        currentLessonNameList.value = (jsonString as List)
            .map((e) => LessonModel.fromJson(e))
            .toList();
  }

  void fetchUserDetails() {
    var profileData = globalController.prefs?.getString(AppStrings.userProfile);
    globalController.userProfile.value = UserProfileModel.fromJson(
      jsonDecode(profileData!),
    );
  }
}
