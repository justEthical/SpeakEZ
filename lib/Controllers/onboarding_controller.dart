import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Constants/app_data.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Controllers/global_controller.dart';
import 'package:speak_ez/Models/onboarding_questions_model.dart';
import 'package:speak_ez/Models/user_profile.dart';
import 'package:speak_ez/Screens/OnBoarding/onboarind_questions.dart';
import 'package:speak_ez/Screens/tab_bar_screen.dart';
import 'package:speak_ez/Services/auth_service.dart';
import 'package:speak_ez/Services/firestore_helper.dart';
import 'package:speak_ez/Services/local_notification.dart';
// import 'package:speak_ez/Services/network_service.dart';
import 'package:speak_ez/Utils/custom_loader.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class OnboardingController extends GetxController {
  final onboardingPageIndicator = PageController(initialPage: 0);
  final onboardingQuestionsController = PageController(initialPage: 0);
  var currentOnboardingQuestionIndex = 0.obs;
  var currentOnboardingIndex = 0.obs;
  var onboardingQuestionAnswerMap = <String, String>{}.obs;
  var switchButtonText = "Login".obs;

  var isloginForm = true.obs;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final loginFormKey = GlobalKey<FormState>();
  final signupFormKey = GlobalKey<FormState>();

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

  Future<void> optionSelected(
    OnboardingQuestion question,
    String selectedLabel,
  ) async {
    await _saveAnswer(question, selectedLabel);

    if (_hasNextQuestion()) {
      _goToNextQuestion();
    } else {
      await _completeOnboarding();
    }
  }

  Future<void> _saveAnswer(OnboardingQuestion question, String label) async {
    switch (question.id) {
      case "appLanguage":
        onboardingQuestionAnswerMap[question.id] = getAppLanguageCode(label);
        return;

      case "preferredPracticeTime":
        final time = await _resolvePracticeTime(question, label);
        debugPrint('Resolved practice time: $time');
        onboardingQuestionAnswerMap[question.id] = time;
        final granted =
            await LocalNotificationService().requestNotificationPermission();
        debugPrint('Notification permission granted: $granted');

        if (granted) {
          // Show immediate test notification to verify notifications work
          // await LocalNotificationService().showTestNotification();

          // Test: Schedule notification for 1 minute from now
          // await LocalNotificationService().testScheduledNotification();

          final scheduled = await LocalNotificationService().scheduleDailyReminder(time: time);
          debugPrint('Scheduled daily reminder for $time: $scheduled');
        } else {
          debugPrint('Notification permission denied, skipping schedule');
        }
        return;

      default:
        onboardingQuestionAnswerMap[question.id] = label;
        return;
    }
  }

  Future<String> _resolvePracticeTime(
    OnboardingQuestion question,
    String label,
  ) async {
    // Custom time option (last option)
    if (label == question.options.last) {
      final pickedTime = await pickPracticeTime(Get.context!);
      return pickedTime ?? "17:00"; // fallback
    }

    // Preset time options
    if (label == question.options.first) {
      return "08:00"; // Morning
    }

    if (label == question.options[1]) {
      return "12:00"; // Afternoon
    }

    return "18:00"; // Evening
  }

  bool _hasNextQuestion() {
    return currentOnboardingQuestionIndex.value < onboardingQuestions.length - 1;
  }

  void _goToNextQuestion() {
    onboardingQuestionsController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
    currentOnboardingQuestionIndex.value++;
  }

  Future<void> _completeOnboarding() async {
    globalController.prefs?.setString(AppStrings.userAuthState, "loggedIn");

    final userProfileData = globalController.prefs?.getString(
      AppStrings.userProfile,
    );

    if (userProfileData == null) {
      debugPrint('User profile data is null in _completeOnboarding');
      return;
    }

    final Map<String, dynamic> userProfile = jsonDecode(userProfileData);

    userProfile.addAll(onboardingQuestionAnswerMap);

    globalController.userProfile.value = UserProfileModel.fromMap(userProfile);

    // await FirestoreHelper.saveCurrentUserProfile(
    //   globalController.userProfile.value,
    // );

    // globalController.prefs?.setString(
    //   AppStrings.userProfile,
    //   jsonEncode(userProfile),
    // );

    globalController.updateProfile();

    _resetOnboardingState();

    Get.offAll(() => const TabBarScreen());
  }

  void _resetOnboardingState() {
    currentOnboardingQuestionIndex.value = 0;
    onboardingQuestionAnswerMap.clear();
    globalController.currentTabIndex.value = 0;
  }

  Future<void> emailLogin(String email, String password) async {
    CustomLoader.showLoader();
    final userData = await AuthService.loginWithEmail(email, password);
    if (userData?.user != null) {
      final notificationTokken = await FirebaseMessaging.instance.getToken();
      await FirestoreHelper.updateUserField({
        'notificationToken': notificationTokken ?? '',
      });
      final userProfile = await FirestoreHelper.fetchCurrentUserProfile();
      if (userProfile != null) {
        globalController.userProfile.value = userProfile;
        globalController.prefs?.setString(
          AppStrings.userProfile,
          jsonEncode(userProfile.toMap()),
        );

        if (globalController.userProfile.value.motherTongue == "") {
          globalController.prefs?.setString(
            AppStrings.userAuthState,
            "onboardingQuestions",
          );
          Get.offAll(() => OnboarindQuestions());
        } else {
          globalController.prefs?.setString(
            AppStrings.userAuthState,
            "loggedIn",
          );
          globalController.currentTabIndex.value = 0;
          Get.offAll(() => TabBarScreen());
        }
      }
    } else {}
    CustomLoader.hideLoader();
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
      globalController.currentTabIndex.value = 0;
      Get.offAll(() => OnboarindQuestions());
    }
    CustomLoader.hideLoader();
  }

  Future<void> googleLogin() async {
    CustomLoader.showLoader();
    final userData = await AuthService.signInWithGoogle();
    if (userData?.user != null) {
      debugPrint(userData!.additionalUserInfo!.isNewUser.toString());
      if (userData.additionalUserInfo!.isNewUser) {
        saveUserProfile(userData);
        Get.offAll(() => OnboarindQuestions());
      } else {
        final notificationTokken = await FirebaseMessaging.instance.getToken();
        await FirestoreHelper.updateUserField({
          'notificationToken': notificationTokken ?? '',
        });
        final userProfile = await FirestoreHelper.fetchCurrentUserProfile();
        if (userProfile != null) {
          globalController.userProfile.value = userProfile;
          globalController.prefs?.setString(
            AppStrings.userProfile,
            jsonEncode(userProfile.toMap()),
          );
          if (globalController.userProfile.value.motherTongue == "") {
            globalController.prefs?.setString(
              AppStrings.userAuthState,
              "onboardingQuestions",
            );
            Get.offAll(() => OnboarindQuestions());
          } else {
            globalController.prefs?.setString(
              AppStrings.userAuthState,
              "loggedIn",
            );
            globalController.currentTabIndex.value = 0;
            Get.offAll(() => TabBarScreen());
          }
        }
      }
    }
    CustomLoader.hideLoader();
  }

  Future<void> saveUserProfile(
    UserCredential userData, {
    String userName = '',
  }) async {
    final notificationToken = await FirebaseMessaging.instance.getToken();

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
      lastActive: DateTime(2000, 1, 1),
      userType: onboardingQuestionAnswerMap['userType'] ?? '',
      motivation: onboardingQuestionAnswerMap['motivation'] ?? '',
      confidence: onboardingQuestionAnswerMap['confidence'] ?? '',
      preferredPractice: onboardingQuestionAnswerMap['preferredPractice'] ?? '',
      motherTongue: onboardingQuestionAnswerMap['motherTongue'] ?? '',
      notificationToken: notificationToken ?? '',
      isShownCustomReviewDialogOnce: false,
      gems: 500,
      weekDaysStreak: WeekDaysStreak.fromMap({}),
      registrationTime: DateTime.now(),
      appLanguage: onboardingQuestionAnswerMap['appLanguage'] ?? 'en',
    );
    globalController.userProfile.value = userProfile;
    globalController.prefs?.setString(
      AppStrings.userProfile,
      jsonEncode(userProfile.toMap()),
    );
    FirestoreHelper.saveCurrentUserProfile(globalController.userProfile.value);
    CustomLoader.hideLoader();
  }

  String getAppLanguageCode(label) {
    final lang = label.split(" ").last;
    for (var language in AppData.appLanguages) {
      if (language.language == lang) {
        return language.code;
      }
    }
    return "en";
  }

  Future<String?> pickPracticeTime(BuildContext context) async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 8, minute: 0), // default
    );

    if (selectedTime != null) {
      // Save time (e.g. 08:00)
      debugPrint('Selected time: ${selectedTime.format(context)}');
      return formatTimeOfDay(selectedTime);
      // TODO: store + schedule notification
    }
    return null;
  }

  String formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  void addLanguageBasedQuestionInOnboarding() {
    // Only show Hindi and Japanese for now
    onboardingQuestions.add(
      OnboardingQuestion(
        id: "motherTongue",
        question: "Which language do you speak at home?",
        options: ["Hindi", "Japanese"],
      ),
    );
    onboardingQuestions.add(
      OnboardingQuestion(
        id: "appLanguage",
        question: "Select App Language. You can change it later from settings",
        options: List.generate(
          AppData.appLanguages.length,
          (i) =>
              "${AppData.appLanguages[i].flag} ${AppData.appLanguages[i].language}",
        ),
      ),
    );
  }
}
