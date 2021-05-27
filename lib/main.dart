import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meetup/view/pages/add_event_page.dart';
import 'package:flutter_meetup/view/pages/splash_page.dart';
import 'view/pages/event_details_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => SplashPage(),
        EventDetailsPage.routeName: (context) => EventDetailsPage(),
        AddEventPage.routeName: (context) => AddEventPage(),
      },
    );
  }
}