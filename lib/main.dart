import 'dart:async';

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
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Controllers/onboarding_controller.dart';
import 'package:speak_ez/Screens/Login/login_screen.dart';
import 'package:speak_ez/Screens/OnBoarding/onboarding_screen.dart';
import 'package:speak_ez/Screens/OnBoarding/onboarind_questions.dart';
import 'package:speak_ez/Screens/tab_bar_screen.dart';
import 'package:speak_ez/Services/firestore_helper.dart';
import 'package:speak_ez/Services/posthog_service.dart';
import 'package:speak_ez/Utils/localization_translation.dart';
import 'package:speak_ez/Utils/theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


import 'Controllers/global_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  unawaited(MobileAds.instance.initialize());
  await dotenv.load(fileName: ".env");

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
        locale: const Locale('en'), // default
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
      body: Center(child: CircularProgressIndicator()),
    );
  }

  getSharePrefsAndRouteUser() async {
    globalController.prefs = await SharedPreferences.getInstance();
    final userAuthState = globalController.prefs?.getString(
      AppStrings.userAuthState,
    );
    if (userAuthState == "loggedIn") {
      Get.offAll(() => TabBarScreen());
    } else if (userAuthState == "loggedOut") {
      Get.offAll(() => LoginSignUp());
    } else if (userAuthState == "onboardingQuestions") {
      Get.offAll(() => OnboarindQuestions());
    } else {
      Get.offAll(() => OnboardingScreen());
    }
  }
}
