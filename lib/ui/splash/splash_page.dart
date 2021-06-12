import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meetup/constants/assets.dart';
import 'package:flutter_meetup/ui/main/main_nav_page.dart';
import 'package:flutter_meetup/viewmodels/utils/Response.dart';
import 'package:flutter_meetup/viewmodels/auth_viewmodel.dart';
import 'package:provider/provider.dart';

import '../login/login_page.dart';

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
      color: Colors.white,
      child: Center(
        child: Image(
            image: AssetImage(Assets.appLogo)
        ),
      ),
    );
  }
}
