import 'package:flutter/material.dart';
import 'package:flutter_meetup/constants/assets.dart';
import 'package:flutter_meetup/constants/strings.dart';
import 'package:flutter_meetup/viewmodels/auth_viewmodel.dart';

class ProfilePage extends StatelessWidget{
  static final title = Strings.PROFILE;
  final Color color;
  final AuthViewModel viewModel = AuthViewModel();

  ProfilePage(this.color);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          key: key,
          appBar: AppBar(
            title: Text(ProfilePage.title),
          ),
          body: ListView(
            children: [
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: NetworkImage(viewModel.getCurrentUser()?.photoURL ?? Assets.placeHolder),
                      fit: BoxFit.fill
                  ),
                ),
              ),
              Text("${Strings.EMAIL}: ${viewModel.getCurrentUser()?.email}"),
              Text(Strings.THEME),
              ElevatedButton(
                child : Text(Strings.LOG_OUT),
                onPressed: () {
                  viewModel.signOut();
                  Navigator.popAndPushNamed(
                    context,
                    '/',
                  );
                },
              ),
            ],
          ),
    );
  }
}