import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

import 'MyHomePage.dart';
import 'PlaceHolderWidget.dart';
import 'explore/CategoriesPage.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    MyHomePage(),
    CategoriesPage(),
    PlaceHolderWidget(Colors.white)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _children[_currentIndex],
        bottomNavigationBar: ConvexAppBar(
          items: [
            TabItem(icon: Icons.home, title: 'Home'),
            TabItem(icon: Icons.search, title: 'Explore'),
            TabItem(icon: Icons.people, title: 'Profile'),
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
