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

  var isloginForm = true.obs;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final loginFormKey = GlobalKey<FormState>();

  bool isValidPassword(String password) {
    final passwordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$',
    );
    return passwordRegex.hasMatch(password);
  }

  bool isValidEmail(String email) {
    // Step 1: Check proper email format
    final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
    if (!emailRegex.hasMatch(email)) return false;

    // Step 2: Allow only popular domains
    final allowedDomains = [
      'gmail.com',
      'outlook.com',
      'live.com',
      'yahoo.com',
      'icloud.com',
      'hotmail.com',
      'protonmail.com',
    ];

    final domain = email.split('@').last.toLowerCase();
    return allowedDomains.contains(domain);
  }

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

  Future<void> emailLogin(String email, String password) async {
    // CustomLoader.showLoader();
    final userData = await AuthService.loginWithEmail(email, password);
    if (userData?.user != null) {
      final userProfile = await FirestoreHelper.fetchCurrentUserProfile();
      if (userProfile != null) {
        globalController.userProfile.value = userProfile;
        globalController.prefs?.setString(
          AppStrings.userProfile,
          jsonEncode(userProfile.toMap()),
        );
        globalController.prefs?.setString(AppStrings.userAuthState, "loggedIn");
        Get.offAll(() => TabBarScreen());
      }
    }else{

    }
    // CustomLoader.hideLoader();
  }

  Future<void> emailSignUp(
    String email,
    String password,
    String userName,
  ) async {
    CustomLoader.showLoader();
    final userData = await AuthService.signUpWithEmail(email, password);
    if (userData?.user != null) {
      saveUserProfile(userData!, userName: userName);
      Get.offAll(() => OnboarindQuestions());
    }
    CustomLoader.hideLoader();
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

  Future<void> saveUserProfile(
    UserCredential userData, {
    String userName = '',
  }) async {
    CustomLoader.showLoader();
    var userProfile = UserProfileModel(
      uid: userData.user!.uid,
      currentEnglishLevel: 'A1',
      currentEnglishLevelProgress: 0,
      currentStreak: 0,
      wordLearned: 0,
      displayName: userData.user!.displayName ?? userName,
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
