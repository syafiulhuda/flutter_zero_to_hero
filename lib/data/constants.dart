import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KTextStyle {
  static TextStyle bodyTextStyle(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: colorScheme.onSurface,
    );
  }

  static Color generalTextStyle(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return colorScheme.onSurface;
  }

  static Color generalColor(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return colorScheme.inversePrimary;
  }
}

class ThemeModePreferences {
  Future<void> saveThemeMode(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
  }

  Future<bool> loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isDarkMode') ?? true;
  }
}
