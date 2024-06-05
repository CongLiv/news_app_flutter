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
    onPrimary: Colors.grey,
    onSecondary: Colors.grey,
    onSurface: Colors.black,
    onError: Colors.white,
  ),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: redViettel,
    selectionColor: redViettel.withOpacity(0.5),
    selectionHandleColor: redViettel,
  ),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    primary: Colors.black54,
    secondary: Colors.black45,
    surface: Colors.black,
    error: Colors.red,
    onPrimary: Color.fromARGB(255, 211, 211, 211),
    onSecondary: Color.fromARGB(255, 211, 211, 211),
    onSurface: Colors.white,
    onError: Colors.white,
  ),

  textSelectionTheme: TextSelectionThemeData(
    cursorColor: redViettel,
    selectionColor: redViettel.withOpacity(0.5),
    selectionHandleColor: redViettel,
  ),
);
