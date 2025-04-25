import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Screens/Login/login_screen.dart';
import 'package:speak_ez/Screens/OnBoarding/onboarding_screen.dart';
import 'package:speak_ez/Utils/theme.dart';

import 'Controllers/global_controller.dart';

void main() async{
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
      initialBinding: BindingsBuilder(() {
        Get.put(GlobalController());
      }),
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system, // 👈 auto switch based on OS
      home: const LoginScreen());
  }
}

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}