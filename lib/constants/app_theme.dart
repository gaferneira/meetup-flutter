import 'package:flutter/material.dart';

import 'colors.dart';
import 'font_family.dart';

final ThemeData themeData = ThemeData(
  scaffoldBackgroundColor: Colors.white,
  fontFamily: FontFamily.productSans,
  brightness: Brightness.light,
  primarySwatch: Colors.green,
  primaryColor: Colors.green,
  primaryColorBrightness: Brightness.light,
  accentColor: Colors.green,
  accentColorBrightness: Brightness.light,
  backgroundColor: Colors.white,
  errorColor: Colors.red,
  dividerColor: Colors.white70,
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.green,
    foregroundColor: Colors.white
  ),
  primaryTextTheme: TextTheme(
    headline6: TextStyle(
      color: Colors.white,
    ),
  ),
  primaryIconTheme: const IconThemeData.fallback().copyWith(
    color: Colors.white,
  ),
);

final ThemeData darkThemeData = ThemeData(
  scaffoldBackgroundColor: Colors.grey.shade900,
  fontFamily: FontFamily.productSans,
  brightness: Brightness.dark,
  primaryColor: Colors.green.shade900,
  primaryColorBrightness: Brightness.dark,
  accentColor: Colors.green.shade900,
  accentColorBrightness: Brightness.dark,
  backgroundColor: Colors.grey.shade900,
  errorColor: Colors.red.shade900,
  dividerColor: Colors.white10,
  floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.green.shade900,
      foregroundColor: Colors.white70
  ),
  primaryTextTheme: TextTheme(
    headline6: TextStyle(
      color: Colors.white70,
    ),
  ),
  primaryIconTheme: const IconThemeData.fallback().copyWith(
    color: Colors.white70,
  ),
);