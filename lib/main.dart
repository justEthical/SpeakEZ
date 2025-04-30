import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speak_ez/Constants/app_strings.dart';
import 'package:speak_ez/Controllers/onboarding_controller.dart';
import 'package:speak_ez/Screens/HomeScreen/home_screen.dart';
import 'package:speak_ez/Screens/Login/login_screen.dart';
import 'package:speak_ez/Screens/OnBoarding/onboarding_screen.dart';
import 'package:speak_ez/Screens/OnBoarding/onboarind_questions.dart';
import 'package:speak_ez/Utils/theme.dart';

import 'Controllers/global_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const AppEntry());
}

class AppEntry extends StatelessWidget {
  const AppEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.cupertino,
      initialBinding: BindingsBuilder(() {
        Get.put(GlobalController());
        Get.put(OnboardingController());
      }),
      theme: lightTheme,
      darkTheme: darkTheme,

      themeMode: ThemeMode.system, // 👈 auto switch based on OS
      home: const Wrapper(),
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
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }

  getSharePrefsAndRouteUser() async {
    globalController.prefs = await SharedPreferences.getInstance();
    final userAuthState = globalController.prefs?.getString(
      AppStrings.userAuthState,
    );
    if (userAuthState == "loggedIn") {
      Get.offAll(() => HomeScreen());
    } else if (userAuthState == "loggedOut") {
      Get.offAll(() => LoginScreen());
    } else if (userAuthState == "onboardingQuestions") {
      Get.offAll(() => OnboarindQuestions());
    } else {
      Get.offAll(() => OnboardingScreen());
    }
  }
}
