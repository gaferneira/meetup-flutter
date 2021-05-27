import 'package:flutter/material.dart';

import 'colors.dart';
import 'font_family.dart';

final ThemeData themeData = new ThemeData(
    fontFamily: FontFamily.productSans,
    brightness: Brightness.light,
    primarySwatch: Colors.green,
    primaryColor: Colors.green[500],
    primaryColorBrightness: Brightness.light,
    accentColor: Colors.green[500],
    accentColorBrightness: Brightness.light
);

final ThemeData themeDataDark = ThemeData(
  fontFamily: FontFamily.productSans,
  brightness: Brightness.dark,
  primaryColor: Colors.green[500],
  primaryColorBrightness: Brightness.dark,
  accentColor: Colors.green[500],
  accentColorBrightness: Brightness.dark,
);