import 'package:flutter/material.dart';
import 'package:flutter_meetup/constants/assets.dart';
import 'package:flutter_meetup/constants/strings.dart';
import 'package:flutter_meetup/di/injection.dart';
import 'package:flutter_meetup/viewmodels/auth_viewmodel.dart';

class ProfilePage extends StatelessWidget{
  static final title = Strings.profile;
  final AuthViewModel viewModel = getIt();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          key: key,
          appBar: AppBar(
            title: Text(ProfilePage.title),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.all(24),
                child: AspectRatio(
                  aspectRatio: 16/9,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: NetworkImage(viewModel.getCurrentUser()?.photoURL ?? Assets.placeHolder),
                          fit: BoxFit.fitHeight
                      ),
                    ),
                  ),
                ),
              ),
              Divider(color: Theme.of(context).dividerColor),
              _buildItem(viewModel.getCurrentUser()?.email ?? Strings.email, context, (){}, Icons.email),
              _buildItem(Strings.theme, context, (){}, Icons.invert_colors),
              _buildItem(Strings.about, context, (){
                Navigator.of(context).restorablePush(_dialogBuilder);
              }, Icons.info),
              _buildItem(Strings.logOut, context, () {
                viewModel.signOut();
                Navigator.popAndPushNamed(
                  context,
                  '/',
                );
              }, Icons.logout),
            ],
          ),
    );
  }

  _buildItem(String title, BuildContext context, Function() onTap, IconData icon) {
    return InkWell(
      onTap: () {
        onTap.call();
      },
      child: Container(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20.0,
              ),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  static Route<Object?> _dialogBuilder(BuildContext context, Object? arguments) {
    return DialogRoute<void>(
      context: context,
      builder: (BuildContext context) => const AlertDialog(title: Text(Strings.aboutUs)),
    );
  }

}