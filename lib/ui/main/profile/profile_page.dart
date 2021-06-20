import 'package:flutter/material.dart';
import 'package:flutter_meetup/constants/assets.dart';
import 'package:flutter_meetup/constants/strings.dart';
import 'package:flutter_meetup/di/injection.dart';
import 'package:flutter_meetup/ui/theme/theme_notifier.dart';
import 'package:flutter_meetup/viewmodels/auth_viewmodel.dart';
import 'package:flutter_meetup/widgets/theme_toggle_widget.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
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
              _buildItem(viewModel.getCurrentUser()?.email ?? Strings.email, (){}, Icons.email),
              _buildThemeToggleItem(context),
              _buildItem(Strings.about, (){
                Navigator.of(context).restorablePush(_dialogBuilder);
              }, Icons.info),
              _buildItem(Strings.logOut, () {
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

  _buildItem(String title, Function() onTap, IconData icon) {
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

  _buildThemeToggleItem(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return Container(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                Icons.invert_colors,
                size: 20.0,
              ),
              SizedBox(width: 8),
              Text(
                themeNotifier.isDarkModeOn() ? Strings.darkMode : Strings.lightMode,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(width: 8),
              ThemeToggleWidget(),
            ],
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