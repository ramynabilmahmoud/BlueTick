import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData getLightTheme() {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Montserrat',
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF5E5AFF),
        brightness: Brightness.light,
        secondary: const Color(0xFF00C2FF),
        tertiary: const Color(0xFF4CAF50),
      ),
    );
  }

  static ThemeData getDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Montserrat',
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF9D94FF),
        brightness: Brightness.dark,
        secondary: const Color(0xFF5EDDFF),
        tertiary: const Color(0xFF7AE582),
      ),
    );
  }
}
