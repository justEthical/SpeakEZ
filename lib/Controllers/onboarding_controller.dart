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
  void optionSelected(OnboardingQuestion model, String label) {
    if (globalController.onboardingQuestionsController.page! <
        onboardingQuestions.length - 1) {
      globalController.onboardingQuestionsController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
      globalController.currentOnboardingQuestionIndex.value++;
      globalController.onboardingQuestionAnswerMap[model.id] = label;
    } else {
      globalController.onboardingQuestionAnswerMap[model.id] = label;
      globalController.prefs?.setString(AppStrings.userAuthState, "loggedIn");
      var userProfileData = globalController.prefs?.getString(
        AppStrings.userProfile,
      );
      Map<String, dynamic> userProfile = jsonDecode(userProfileData!);
      userProfile.addAll(globalController.onboardingQuestionAnswerMap);
      globalController.prefs?.setString(
        AppStrings.userProfile,
        jsonEncode(userProfile),
      );
      Get.offAll(() => const HomeScreen());
    }
  }

  void googleLogin() async {
    final userData = await AuthService.signInWithGoogle();
    if (userData != null) {
      var userProfile = {
        "uid": userData.uid,
        "name": userData.displayName,
        "email": userData.email,
        "imageUrl": userData.photoURL,
      };
      globalController.prefs?.setString(
        AppStrings.userProfile,
        jsonEncode(userProfile),
      );
      Get.offAll(() => OnboarindQuestions());
    }
  }

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
