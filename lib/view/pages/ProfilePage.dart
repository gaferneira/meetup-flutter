import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget{
  static final title = "Profile";
  final Color color;

  ProfilePage(this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: color
    );
  }
}