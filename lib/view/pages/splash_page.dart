import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meetup/view/main_nav_page.dart';
import 'package:flutter_meetup/view/pages/login_page.dart';
import 'package:flutter_meetup/viewmodel/auth_viewmodel.dart';
import 'package:flutter_meetup/viewmodel/utils/Response.dart';
import 'package:provider/provider.dart';

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
