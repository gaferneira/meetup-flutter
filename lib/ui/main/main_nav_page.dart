import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

import 'home/home_page.dart';
import 'profile/profile_page.dart';
import 'explore/explore_page.dart';

class MainNavPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainNavPageState();
  }
}

class _MainNavPageState extends State<MainNavPage> {
  PageController? pageController;
  int _currentIndex = 0;
  final List<Widget> _children = [
    HomePage(),
    ExplorePage(),
    ProfilePage(),
  ];


  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
          children: _children,
          controller: pageController,
          onPageChanged: onPageChanged,
        ),
        bottomNavigationBar: ConvexAppBar(
          items: [
            TabItem(icon: Icons.home, title: HomePage.title),
            TabItem(icon: Icons.search, title: ExplorePage.title),
            TabItem(icon: Icons.people, title: ProfilePage.title),
          ],
          initialActiveIndex: _currentIndex,
          style: TabStyle.react,
          backgroundColor: Theme.of(context).primaryColor,
          top: -15,
          onTap: onTabTapped,
        )
    );
  }

  onTabTapped(int index) {
    onPageChanged(index);
    pageController?.jumpToPage(index);
  }

  onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void dispose() {
    pageController?.dispose();
    super.dispose();
  }
}
