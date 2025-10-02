import 'package:flutter/material.dart';
import 'package:speak_ez/Constants/app_strings.dart';

final MaterialColor primarySwatch = MaterialColor(0xFF4A90E2, <int, Color>{
  50: Color(0xFFE3F2FD),
  100: Color(0xFFBBDEFB),
  200: Color(0xFF90CAF9),
  300: Color(0xFF64B5F6),
  400: Color(0xFF42A5F5),
  500: Color(0xFF4A90E2), // Your primary
  600: Color(0xFF1E88E5),
  700: Color(0xFF1976D2),
  800: Color(0xFF1565C0),
  900: Color(0xFF0D47A1),
});

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: primarySwatch,
  scaffoldBackgroundColor: Color(0xFFF5F6FA),
  colorScheme: ColorScheme.light(
    primary: Colors.deepPurple,
    secondary: Colors.deepOrange,
    tertiary: Colors.blueAccent,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.black,
  ),
  fontFamily: AppStrings.nunitoFont,
  textTheme: const TextTheme(
    displayLarge: TextStyle(color: Colors.black),
    displayMedium: TextStyle(color: Colors.black),
    displaySmall: TextStyle(color: Colors.black),
    headlineLarge: TextStyle(color: Colors.black),
    headlineMedium: TextStyle(color: Colors.black),
    headlineSmall: TextStyle(color: Colors.black),
    titleLarge: TextStyle(color: Colors.black),
    titleMedium: TextStyle(color: Colors.black),
    titleSmall: TextStyle(color: Colors.black),
    bodyLarge: TextStyle(color: Colors.black),
    bodyMedium: TextStyle(color: Colors.black),
    bodySmall: TextStyle(color: Colors.black),
    labelLarge: TextStyle(color: Colors.black),
    labelMedium: TextStyle(color: Colors.black),
    labelSmall: TextStyle(color: Colors.black),
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: primarySwatch,
  scaffoldBackgroundColor: Color(0xFF121212),
  colorScheme: ColorScheme.dark(
    primary: Colors.deepPurple,
    secondary: Colors.deepOrange,
    tertiary: Colors.blueAccent,
    onPrimary:  Colors.white,
    onSecondary: const Color.fromARGB(255, 47, 44, 52),
    onSurface: Colors.white,
  ),
  fontFamily: AppStrings.nunitoFont,
  textTheme: const TextTheme(
    displayLarge: TextStyle(color: Colors.white),
    displayMedium: TextStyle(color: Colors.white),
    displaySmall: TextStyle(color: Colors.white),
    headlineLarge: TextStyle(color: Colors.white),
    headlineMedium: TextStyle(color: Colors.white),
    headlineSmall: TextStyle(color: Colors.white),
    titleLarge: TextStyle(color: Colors.white),
    titleMedium: TextStyle(color: Colors.white),
    titleSmall: TextStyle(color: Colors.white),
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white),
    bodySmall: TextStyle(color: Colors.white),
    labelLarge: TextStyle(color: Colors.white),
    labelMedium: TextStyle(color: Colors.white),
    labelSmall: TextStyle(color: Colors.white),
  ),
);
