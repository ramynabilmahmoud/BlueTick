import 'package:shared_preferences/shared_preferences.dart';

class ThemeRepository {
  static const String isDarkModeKey = 'isDarkMode';

  Future<bool> loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isDarkModeKey) ?? false;
  }

  Future<void> saveThemePreference(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(isDarkModeKey, isDarkMode);
  }
}
