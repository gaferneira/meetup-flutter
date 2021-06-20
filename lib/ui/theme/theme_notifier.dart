import 'package:flutter/material.dart';
import 'package:flutter_meetup/constants/app_theme.dart';
import 'package:flutter_meetup/constants/strings.dart';
import 'package:flutter_meetup/di/injection.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends ChangeNotifier {

  final SharedPreferences sharedPrefs = getIt();

  ThemeData _themeData;

  ThemeNotifier(this._themeData);

  getTheme() => _themeData;

  isDarkModeOn() => _themeData == darkThemeData;

  setTheme(bool darkModeOn) async {
    sharedPrefs.setBool(Strings.darkModeOn, darkModeOn);
    _themeData = darkModeOn ? darkThemeData : themeData;
    notifyListeners();
  }
}