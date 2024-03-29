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
  toggleableActiveColor: Colors.green,
);

final ThemeData darkThemeData = ThemeData(
  scaffoldBackgroundColor: Colors.grey.shade900,
  fontFamily: FontFamily.productSans,
  brightness: Brightness.dark,
  primarySwatch: MaterialColor(0xFF1B5E20, darkSwatchColor),
  primaryColor: Colors.green.shade900,
  primaryColorBrightness: Brightness.dark,
  accentColor: Colors.green.shade900,
  accentColorBrightness: Brightness.dark,
  backgroundColor: Colors.grey.shade900,
  errorColor: Colors.red.shade900,
  dividerColor: Colors.white10,
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.green.shade900,
    foregroundColor: Colors.white,
  ),
  primaryTextTheme: TextTheme(
    headline6: TextStyle(
      color: Colors.white,
    ),
  ),
  primaryIconTheme: const IconThemeData.fallback().copyWith(
    color: Colors.white,
  ),
  toggleableActiveColor: Colors.green.shade900,
);

Map<int, Color> darkSwatchColor =
{
  50:Colors.green.shade50,
  100:Colors.green.shade100,
  200:Colors.green.shade200,
  300:Colors.green.shade300,
  400:Colors.green.shade400,
  500:Colors.green.shade500,
  600:Colors.green.shade600,
  700:Colors.green.shade700,
  800:Colors.green.shade800,
  900:Colors.green.shade900,
};