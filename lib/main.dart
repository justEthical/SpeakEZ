import 'dart:async';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sherpa_onnx/sherpa_onnx.dart'as sherpa_onnx;
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Controllers/onboarding_controller.dart';
import 'package:speak_ez/Controllers/practice_controller.dart';
import 'package:speak_ez/Screens/Login/login_screen.dart';
import 'package:speak_ez/Screens/OnBoarding/onboarding_screen.dart';
import 'package:speak_ez/Screens/OnBoarding/onboarind_questions.dart';
import 'package:speak_ez/Screens/tab_bar_screen.dart';
import 'package:speak_ez/Services/firestore_helper.dart';
import 'package:speak_ez/Services/local_notification.dart';
import 'package:speak_ez/Services/posthog_service.dart';
import 'package:speak_ez/Utils/localization_translation.dart';
import 'package:speak_ez/Utils/theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'Controllers/global_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // App Check gates the Cloudflare proxy that holds the DeepInfra key.
  // Debug builds skip attestation and authenticate to the proxy with a shared
  // dev secret instead (see NetworkService), so there is no per-install App
  // Check debug token to register. Release builds always attest for real.
  if (!kDebugMode) {
    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.playIntegrity,
      appleProvider: AppleProvider.appAttest,
    );
  }
  unawaited(MobileAds.instance.initialize());
  await dotenv.load(fileName: ".env");
  LocalNotificationService().init();
  sherpa_onnx.initBindings(); // FFI bindings for sherpa-onnx
  await PostHogService.instance.initialize();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    PostHogService.instance.captureError(
      'flutter_error',
      errorMessage: errorDetails.exception.toString(),
      stackTrace: errorDetails.stack.toString(),
    );
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    PostHogService.instance.captureError(
      'platform_error',
      errorMessage: error.toString(),
      stackTrace: stack.toString(),
    );
    return true;
  };
  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
    FirestoreHelper.updateUserField({
      'notificationToken': newToken,
    }); // 🔄 handle token update here
  });
  runApp(const AppEntry());
}

class AppEntry extends StatelessWidget {
  const AppEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return PostHogWidget(
      child: GetMaterialApp(
        translations: AppTranslations(),
        locale: Get.deviceLocale, // default
        fallbackLocale: const Locale('en'),
        supportedLocales: const [
          Locale('en'),
          Locale('ja'),
          Locale('hi'),
          Locale('es'),
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        debugShowCheckedModeBanner: false,
        defaultTransition: Transition.cupertino,
        initialBinding: BindingsBuilder(() {
          Get.put(GlobalController());
          Get.put(OnboardingController());
          Get.lazyPut<PracticeController>(
            () => PracticeController(),
            fenix: true,
          );
        }),
        navigatorObservers: [PosthogObserver()],
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.system, // 👈 auto switch based on OS
        home: const Wrapper(),
      ),
    );
  }
}

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSharePrefsAndRouteUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(child: Center(child: CircularProgressIndicator())),
    );
  }

  getSharePrefsAndRouteUser() async {
    globalController.prefs = await SharedPreferences.getInstance();
    final userAuthState = globalController.prefs?.getString(
      AppStrings.userAuthState,
    );
    if (userAuthState == "loggedIn") {
      // Fetch user profile and reschedule notification (handles reinstall scenario)
      await _loadUserProfileAndRescheduleNotification();
      Get.offAll(() => TabBarScreen());
    } else if (userAuthState == "loggedOut") {
      Get.offAll(() => LoginSignUp());
    } else if (userAuthState == "onboardingQuestions") {
      Get.offAll(() => OnboarindQuestions());
    } else {
      Get.offAll(() => OnboardingScreen());
    }
  }

  /// Fetches user profile from Firestore and reschedules daily notification
  /// This handles the reinstall scenario where local notifications are cleared
  Future<void> _loadUserProfileAndRescheduleNotification() async {
    try {
      final userProfile = await FirestoreHelper.fetchCurrentUserProfile();
      if (userProfile != null) {
        globalController.userProfile.value = userProfile;

        // Reschedule notification if user has a preferred practice time
        if (userProfile.preferredPracticeTime.isNotEmpty) {
          var hasPermission =
              await LocalNotificationService().hasNotificationPermission();
          if (!hasPermission) {
            hasPermission =
                await LocalNotificationService()
                    .requestNotificationPermission();
          }
          if (hasPermission) {
            await LocalNotificationService().scheduleDailyReminder(
              time: userProfile.preferredPracticeTime,
            );
            debugPrint(
              'Rescheduled daily reminder for ${userProfile.preferredPracticeTime}',
            );
          }
        }
      }
    } catch (e) {
      debugPrint('Error loading user profile: $e');
    }
  }
}
