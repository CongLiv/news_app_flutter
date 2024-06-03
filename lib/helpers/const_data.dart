import 'package:flutter/material.dart';

const redViettel = Color.fromARGB(255, 230, 25, 52);
const appNameLogo = 'VDT NEWS';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    primary: Colors.white,
    secondary: Colors.white,
    surface: Colors.white,
    error: Colors.red,
    onPrimary: Colors.white38,
    onSecondary: Colors.white38,
    onSurface: Colors.black,
    onError: Colors.white,
  ),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    primary: Colors.black54,
    secondary: Colors.black45,
    surface: Colors.black,
    error: Colors.red,
    onPrimary: Colors.white38,
    onSecondary: Colors.white38,
    onSurface: Colors.white,
    onError: Colors.white,
  ),
);
