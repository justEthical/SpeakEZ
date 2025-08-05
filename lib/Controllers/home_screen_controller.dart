import 'dart:convert';

import 'package:get/get.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Controllers/global_controller.dart';
import 'package:speak_ez/Models/lesson_model.dart';
import 'package:speak_ez/Models/user_profile.dart';
import 'package:speak_ez/Services/firestore_helper.dart';

class HomeScreenController extends GetxController {
  var currenEnglishLessonLevel = "A1".obs;
  var currentLessonNameList = <Lesson>[].obs;

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    // Future.delayed(Duration.zero, () async {
    //   currentLessonNameList.value = await loadLessonsFromJson("A1");
    // });
  }

  void changeEnglishLevel(String level) async {
    // switch (level) {
    //   case "A1":
    //     currenEnglishLessonLevel.value = "A1";
    //     loadLessonsFromJson('assets/lessons/a1.json');
    //     break;
    //   case "A2":
    //     currenEnglishLessonLevel.value = "A2";
    //     loadLessonsFromJson('assets/lessons/a2.json');
    //     break;
    //   case "B1":
    //     currenEnglishLessonLevel.value = "B1";
    //     loadLessonsFromJson('assets/lessons/b1.json');
    //     break;
    //   case "B2":
    //     currenEnglishLessonLevel.value = "B2";
    //     loadLessonsFromJson('assets/lessons/b2.json');
    //     break;
    //   case "C1":
    //     currenEnglishLessonLevel.value = "C1";
    //     loadLessonsFromJson('assets/lessons/c1.json');
    //     break;
    //   case "C2":
    //     currenEnglishLessonLevel.value = "C2";
    //     loadLessonsFromJson('assets/lessons/c2.json');
    //     break;
    // }
    currenEnglishLessonLevel.value = level;
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

  final lessonListPath = {
    'A1': 'assets/lessons/a1.json',
    'A2': 'assets/lessons/a2.json',
    'B1': 'assets/lessons/b1.json',
    'B2': 'assets/lessons/b2.json',
    'C1': 'assets/lessons/c1.json',
    'C2': 'assets/lessons/c2.json',
  };

  // Future<List<LessonModel>> loadLessonsFromJson(String englishLevel) async {
  //   final content = await rootBundle.loadString(lessonListPath[englishLevel]!);
  //   final jsonString = jsonDecode(content.toString());
  //   final lessonsList =
  //       (jsonString as List).map((e) => LessonModel.fromJson(e)).toList();
  //   return lessonsList;
  // }

  void fetchUserDetails() {
    var profileData = globalController.prefs?.getString(AppStrings.userProfile);
    globalController.userProfile.value = UserProfileModel.fromMap(
      jsonDecode(profileData!),
    );
    calculateStreak();
  }
}
