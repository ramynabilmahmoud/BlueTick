import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData getLightTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF5E5AFF),
        brightness: Brightness.light,
        secondary: const Color(0xFF00C2FF),
        tertiary: const Color(0xFF4CAF50),
      ),
      // Other light theme settings
    );
  }

  static ThemeData getDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF9D94FF),
        brightness: Brightness.dark,
        // Other settings
      ),
      // Other dark theme settings
    );
  }
}
