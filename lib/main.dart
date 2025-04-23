import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Screens/OnBoarding/onboarding_screen.dart';

import 'Controllers/global_controller.dart';

void main() {
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
      home: const OnboardingScreen());
  }
}


final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.deepPurple,
  scaffoldBackgroundColor: Colors.white,
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.black),
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.deepPurple,
  scaffoldBackgroundColor: Color(0xFF121212),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
  ),
);
