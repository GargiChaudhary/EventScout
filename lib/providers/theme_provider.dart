import 'package:events/utils/colors.dart';
import 'package:events/utils/palette.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.dark;
  bool get isDarkMode => themeMode == ThemeMode.dark;

  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class MyThemes {
  static final darkTheme = ThemeData(
      focusColor: darkcolor4,
      hintColor: Colors.white,
      fontFamily: 'Montserrat',
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color.fromRGBO(35, 35, 35, 1),
      primaryColor: darkcolor4,
      primarySwatch: Palette.myPink,
      useMaterial3: true,
      colorScheme: const ColorScheme.dark());
  static final lightTheme = ThemeData(
      focusColor: Colors.white,
      hintColor: Colors.black,
      brightness: Brightness.light,
      fontFamily: 'Montserrat',
      scaffoldBackgroundColor: const Color(0xFFFFFFFF),
      primaryColor: const Color(0xfff6a192),
      primarySwatch: Palette.myPink,
      useMaterial3: true,
      colorScheme: const ColorScheme.light());
}
