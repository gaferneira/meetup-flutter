import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/BookDetailsPage.dart';
import 'pages/Home.dart';
import 'pages/login/AuthViewModel.dart';
import 'pages/login/LoginPage.dart';

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
        BookDetailsPage.routeName: (context) => BookDetailsPage(),
      },
    );
  }
}

class SplashPage extends StatelessWidget {
  final AuthViewModel viewModel = AuthViewModel();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthViewModel>.value(
      value: viewModel,
      child: Consumer(
        builder: (context, AuthViewModel viewModel, _) {
          switch (viewModel.status) {
            case AuthStatus.Unauthenticated:
              return LoginPage();
            case AuthStatus.Authenticated:
              return Home();
            case AuthStatus.Uninitialized:
            default:
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
