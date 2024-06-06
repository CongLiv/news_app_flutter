import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app_flutter_demo/helpers/const_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeProvider = StateNotifierProvider<ThemeProvider, ThemeData>((ref) {
  return ThemeProvider();
});

class ThemeProvider extends StateNotifier<ThemeData> {
  ThemeProvider() : super(lightTheme) {
    loadThemeMode();
  }

  Future<void> loadThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isDarkMode = prefs.getBool('isDarkMode');

    if (isDarkMode != null) {
      state = isDarkMode ? darkTheme : lightTheme;
    } else {
      state = lightTheme; // Default theme
    }
  }

  Future<void> toggleTheme() async {
    if (state == lightTheme) {
      state = darkTheme;
    } else {
      state = lightTheme;
    }

    // Save theme mode to SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode());
  }

  bool isDarkMode() {
    return state == darkTheme;
  }
}


