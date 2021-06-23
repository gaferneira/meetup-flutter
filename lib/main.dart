import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meetup/constants/app_theme.dart';
import 'package:flutter_meetup/models/event.dart';
import 'package:flutter_meetup/ui/main/event_details_page.dart';
import 'package:flutter_meetup/ui/main/explore/events_page.dart';
import 'package:flutter_meetup/ui/main/home/add_event_page.dart';
import 'package:flutter_meetup/ui/splash/splash_page.dart';
import 'package:flutter_meetup/ui/theme/theme_notifier.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants/strings.dart';
import 'di/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await configureInjection();
  GetIt.I.isReady<SharedPreferences>().then((_) {
    final SharedPreferences sharedPrefs = getIt();
    var darkModeOn = sharedPrefs.getBool(Strings.darkModeOn) ?? false;
    runApp(
      ChangeNotifierProvider<ThemeNotifier>(
        create: (_) => ThemeNotifier(darkModeOn ? darkThemeData : themeData),
        child: MyApp(),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Strings.appName,
      initialRoute: '/',
      theme: Provider.of<ThemeNotifier>(context).getTheme(),
      onGenerateRoute: (settings) {
        // When navigating to the "/" route, build the FirstScreen widget.
        switch (settings.name) {
          case "/" : return MaterialPageRoute(builder: (context) => SplashPage());
          case EventDetailsPage.routeName : return MaterialPageRoute(builder: (context) {
            return EventDetailsPage(event : settings.arguments as Event);
          });
          case AddEventPage.routeName : return MaterialPageRoute(builder: (context) {
            return AddEventPage(settings.arguments as Event?);
          });
          case EventsPage.routeName : return MaterialPageRoute(builder: (context) => EventsPage());
        }
      },
    );
  }
}
