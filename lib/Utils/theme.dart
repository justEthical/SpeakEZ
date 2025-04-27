import 'package:flutter/material.dart';
import 'package:speak_ez/Constants/app_strings.dart';

final MaterialColor customBlue = MaterialColor(0xFF4A90E2, <int, Color>{
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
  primarySwatch: customBlue,
  scaffoldBackgroundColor: Color(0xFFF5F6FA),
  colorScheme: ColorScheme.light(
    primary: Color(0xFF4A90E2),
    secondary: Color(0xFF7ED6DF),
    tertiary: Color(0xFFFDCB6E),
  ),
  fontFamily: AppStrings.nunitoFont,
  textTheme: const TextTheme(bodyLarge: TextStyle(color: Colors.black)),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: customBlue,
  scaffoldBackgroundColor: Color(0xFF121212),
  colorScheme: ColorScheme.dark(
    primary: Color(0xFF4A90E2),
    secondary: Color(0xFF7ED6DF),
    tertiary: Colors.amber,
  ),
  fontFamily: AppStrings.nunitoFont,
  textTheme: const TextTheme(bodyLarge: TextStyle(color: Colors.white)),
);
