import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Controllers/global_controller.dart';
import 'package:speak_ez/Models/country_languages.dart';
import 'package:speak_ez/Models/onboarding_questions_model.dart';
import 'package:speak_ez/Screens/HomeScreen/home_screen.dart';
import 'package:speak_ez/Screens/OnBoarding/onboarind_questions.dart';
import 'package:speak_ez/Services/auth_service.dart';
import 'package:speak_ez/Services/network_service.dart';

class OnboardingController extends GetxController {
  final onboardingPageIndicator = PageController(initialPage: 0);
  final onboardingQuestionsController = PageController(initialPage: 0);
  var currentOnboardingQuestionIndex = 0.obs;
  var currentOnboardingIndex = 0.obs;
  var onboardingQuestionAnswerMap = <String, String>{}.obs;

  /// Call when an option is selected in OnboardingQuestions screen.
  ///
  /// If the selected option is not the last question, then navigate to the
  /// next question. Store the selected option in the global controller.
  ///
  /// If the selected option is the last question, then set the user profile
  /// in the shared preferences and navigate to the HomeScreen.
  void optionSelected(OnboardingQuestion model, String label) {
    if (onboardingQuestionsController.page! < onboardingQuestions.length - 1) {
      onboardingQuestionsController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
      currentOnboardingQuestionIndex.value++;
      onboardingQuestionAnswerMap[model.id] = label;
    } else {
      onboardingQuestionAnswerMap[model.id] = label;
      globalController.prefs?.setString(AppStrings.userAuthState, "loggedIn");
      var userProfileData = globalController.prefs?.getString(
        AppStrings.userProfile,
      );
      Map<String, dynamic> userProfile = jsonDecode(userProfileData!);
      userProfile.addAll(onboardingQuestionAnswerMap);
      globalController.prefs?.setString(
        AppStrings.userProfile,
        jsonEncode(userProfile),
      );

      Get.offAll(() => const HomeScreen());
    }
  }

  void googleLogin() async {
    final userData = await AuthService.signInWithGoogle();
    if (userData?.user != null) {
      var userProfile = {
        "uid": userData?.user?.uid,
        "name": userData?.user?.displayName,
        "email": userData?.user?.email,
        "imageUrl": userData?.user?.photoURL,
      };
      globalController.prefs?.setString(
        AppStrings.userProfile,
        jsonEncode(userProfile),
      );
      print(userData!.additionalUserInfo!.isNewUser);
      if (userData.additionalUserInfo!.isNewUser) {
        Get.offAll(() => OnboarindQuestions());
      } else {
        globalController.prefs?.setString(AppStrings.userAuthState, "loggedIn");
        Get.offAll(() => HomeScreen());
      }
    }
  }

  /*************  ✨ Windsurf Command ⭐  *************/
  /// Adds a language based question in the onboardingQuestions list.
  ///
  /// This question asks the user which language they speak at home.
  /// The options are based on the user's country.
  /// *****  4e777342-ad44-4f6c-bfcd-ef372e6b7212  ******
  void addLanguageBasedQuestionInOnboarding() async {
    final countryCode = await NetworkService.getUserCountryFromIP();
    for (var country in countryLanguages) {
      if (country.countryCode == countryCode) {
        onboardingQuestions.add(
          OnboardingQuestion(
            id: "MotherTongue",
            question: "Which language do you speak at home?",
            options: country.languages,
          ),
        );
      }
    }
  }
}
