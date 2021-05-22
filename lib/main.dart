import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meetup/view/pages/AddEventPage.dart';
import 'package:flutter_meetup/viewmodel/utils/Response.dart';
import 'package:provider/provider.dart';

import 'view/pages/EventDetailsPage.dart';
import 'view/MainNavPage.dart';
import 'viewmodel/AuthViewModel.dart';
import 'view/pages/LoginPage.dart';

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

class SplashPage extends StatelessWidget {
  final AuthViewModel viewModel = AuthViewModel();

  @override
  Widget build(BuildContext context) {
    viewModel.autoLogin();
    return ChangeNotifierProvider<AuthViewModel>.value(
      value: viewModel,
      child: Consumer(
        builder: (context, AuthViewModel viewModel, _) {
          if (viewModel.response.state == ResponseState.COMPLETE) {
            switch (viewModel.response.data) {
              case AuthStatus.UNAUTHENTICATED:
                return LoginPage();
              case AuthStatus.AUTHENTICATED:
                return MainNavPage();
              case AuthStatus.UNINITIALIZED:
              default:
                return showSplash();
            }
          } else {
            return showSplash();
          }
        },
      ),
    );
  }

  Widget showSplash() {
    return Material(
      color: Colors.blueAccent,
      child: Center(
        child: Text(
          "Splash",
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
