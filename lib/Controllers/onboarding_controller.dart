import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Controllers/global_controller.dart';
import 'package:speak_ez/Models/country_languages.dart';
import 'package:speak_ez/Models/onboarding_questions_model.dart';
import 'package:speak_ez/Models/user_profile.dart';
import 'package:speak_ez/Screens/OnBoarding/onboarind_questions.dart';
import 'package:speak_ez/Screens/tab_bar_screen.dart';
import 'package:speak_ez/Services/auth_service.dart';
import 'package:speak_ez/Services/firestore_helper.dart';
import 'package:speak_ez/Services/network_service.dart';
import 'package:speak_ez/Utils/custom_loader.dart';

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
      globalController.userProfile.value = UserProfileModel.fromMap(
        userProfile,
      );
      FirestoreHelper.saveCurrentUserProfile(
        globalController.userProfile.value,
      );
      globalController.prefs?.setString(
        AppStrings.userProfile,
        jsonEncode(userProfile),
      );

      Get.offAll(() => const TabBarScreen());
    }
  }

  Future<void> googleLogin() async {
    final userData = await AuthService.signInWithGoogle();
    if (userData?.user != null) {
      print(userData!.additionalUserInfo!.isNewUser);
      if (userData.additionalUserInfo!.isNewUser) {
        saveUserProfile(userData);
        Get.offAll(() => OnboarindQuestions());
      } else {
        final userProfile = await FirestoreHelper.fetchCurrentUserProfile();
        if (userProfile != null) {
          globalController.userProfile.value = userProfile;
          globalController.prefs?.setString(
            AppStrings.userProfile,
            jsonEncode(userProfile.toMap()),
          );
          globalController.prefs?.setString(
            AppStrings.userAuthState,
            "loggedIn",
          );
          Get.offAll(() => TabBarScreen());
        }
      }
    }
  }

  Future<void> saveUserProfile(UserCredential userData) async {
    CustomLoader.showLoader();
    var userProfile = UserProfileModel(
      uid: userData.user!.uid,
      currentEnglishLevel: 'A1',
      currentLessonProgress: 0,
      currentStreak: 0,
      wordLearned: 0,
      displayName: userData.user!.displayName ?? 'User',
      photoUrl: userData.user!.photoURL,
      email: userData.user!.email!,
      lastActive: DateTime.now(),
      userType: onboardingQuestionAnswerMap['userType'] ?? '',
      motivation: onboardingQuestionAnswerMap['motivation'] ?? '',
      confidence: onboardingQuestionAnswerMap['confidence'] ?? '',
      preferredPractice: onboardingQuestionAnswerMap['preferredPractice'] ?? '',
      motherTongue: onboardingQuestionAnswerMap['motherTongue'] ?? '',
    );
    globalController.userProfile.value = userProfile;
    globalController.prefs?.setString(
      AppStrings.userProfile,
      jsonEncode(userProfile.toMap()),
    );
    FirestoreHelper.saveCurrentUserProfile(globalController.userProfile.value);
    CustomLoader.hideLoader();
  }

  void addLanguageBasedQuestionInOnboarding() async {
    final countryCode = await NetworkService.getUserCountryFromIP();
    for (var country in countryLanguages) {
      if (country.countryCode == countryCode) {
        onboardingQuestions.add(
          OnboardingQuestion(
            id: "motherTongue",
            question: "Which language do you speak at home?",
            options: country.languages,
          ),
        );
      }
    }
  }
}
