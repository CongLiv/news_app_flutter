import 'package:flutter/material.dart';
import 'package:news_app_flutter_demo/helpers/const_data.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightTheme;

  ThemeData get themData {
    return _themeData;
  }

  void toggleTheme() {
    if (_themeData == lightTheme) {
      _themeData = darkTheme;
    } else {
      _themeData = lightTheme;
    }
    notifyListeners();
  }

  bool isDarkMode() {
    return _themeData == darkTheme;
  }
}
