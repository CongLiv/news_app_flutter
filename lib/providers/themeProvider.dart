import 'package:flutter/material.dart';
import 'package:news_app_flutter_demo/helpers/const_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/article/homepage.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightTheme;

  ThemeProvider() {
    loadThemeMode();
  }

  ThemeData get themData {
    return _themeData;
  }

  Future<void> loadThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isDarkMode = prefs.getBool('isDarkMode');

    if (isDarkMode != null) {
      _themeData = isDarkMode ? darkTheme : lightTheme;
      notifyListeners();
    }
  }

  Future<void> toggleTheme() async {
    if (_themeData == lightTheme) {
      _themeData = darkTheme;
    } else {
      _themeData = lightTheme;
    }
    notifyListeners();

    // Save theme mode to SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode());
  }

  bool isDarkMode() {
    return _themeData == darkTheme;
  }
}
