import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meetup/ui/theme/theme_notifier.dart';
import 'package:provider/provider.dart';

class ThemeToggleWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return Switch.adaptive(
      value: themeNotifier.isDarkModeOn(),
      onChanged: (darkModeOn) {
        if (darkModeOn != themeNotifier.isDarkModeOn())
          themeNotifier.setTheme(darkModeOn);
      },
    );
  }

}