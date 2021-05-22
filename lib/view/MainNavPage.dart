import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

import 'pages/HomePage.dart';
import 'pages/ProfilePage.dart';
import 'pages/ExplorePage.dart';

class MainNavPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainNavPageState();
  }
}

class _MainNavPageState extends State<MainNavPage> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    HomePage(),
    ExplorePage(),
    ProfilePage(Colors.white)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _children[_currentIndex],
        bottomNavigationBar: ConvexAppBar(
          items: [
            TabItem(icon: Icons.home, title: HomePage.title),
            TabItem(icon: Icons.search, title: ExplorePage.title),
            TabItem(icon: Icons.people, title: ProfilePage.title),
          ],
          initialActiveIndex: _currentIndex,
          style: TabStyle.react,
          backgroundColor: Colors.white10,
          color: Colors.black,
          activeColor: Colors.lightGreen,
          top: -15,
          onTap: onTabTapped,
        ));
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
