import 'dart:async';

import 'package:flutter/material.dart';
import '../../data/entities/Category.dart';
import '../../data/repositories/CategoriesRepository.dart';

class ExplorePage extends StatefulWidget {
  static final title = "Explore";

  ExplorePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CategoriesPage();
  }
}

class _CategoriesPage extends State<ExplorePage> {
  CategoriesRepository categoriesRepository = CategoriesRepository();
  StreamSubscription? streamSubscription;

  int categoriesSize = 0;

  List<Category> categoriesList = [];

  @override
  void initState() {
    streamSubscription =
        categoriesRepository.fetchCategories().listen((newList) {
      setState(() {
        categoriesSize = newList.length;
        categoriesList = newList;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightGreen,
          title: Text("Explore"),
        ),
        body: new Center(
          child: GridView.count(
              crossAxisCount: 2,
              children: List.generate(categoriesSize,
                  (index) => _buildItemCategory(categoriesList[index]))),
        ));
  }

  Widget _buildItemCategory(Category category) {
    return new Center(
      child: Column(
        children: [
          FadeInImage.assetNetwork(
            placeholder: "assets/globant_placeholder.png",
            image: category.image!,
            fit: BoxFit.fill,
            placeholderCacheHeight: 90,
            placeholderCacheWidth: 120,
            height: 120,
            width: 150,
          ),
          Text(
            category.name!,
            maxLines: 2,
            style: Theme.of(context).textTheme.subtitle1,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    streamSubscription?.cancel();
    super.dispose();
  }
}
