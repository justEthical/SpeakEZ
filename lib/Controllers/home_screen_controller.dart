import 'dart:convert';

import 'package:get/get.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Controllers/global_controller.dart';
import 'package:speak_ez/Models/user_profile_model.dart';

class HomeScreenController extends GetxController {
  void fetchUserDetails() {
    var profileData = globalController.prefs?.getString(
        AppStrings.userProfile,
      );
      globalController.userProfile.value = UserProfileModel.fromJson(
        jsonDecode(profileData!),
      );
  }
}