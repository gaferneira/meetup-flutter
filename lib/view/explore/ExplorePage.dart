import 'package:flutter/material.dart';
import 'package:flutter_meetup/viewmodel/ExploreViewModel.dart';
import 'package:flutter_meetup/viewmodel/utils/Reponse.dart';
import 'package:provider/provider.dart';
import '../../model/entities/Category.dart';

class ExplorePage extends StatefulWidget {
  static final title = "Explore";

  ExplorePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CategoriesPage();
  }
}

class _CategoriesPage extends State<ExplorePage> {
  ExploreViewModel viewModel = ExploreViewModel();

  @override
  void initState() {
    viewModel.fetchCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightGreen,
          title: Text("Explore"),
        ),
        body: ChangeNotifierProvider<ExploreViewModel>.value(
          value: viewModel,
          child: Consumer(
              builder: (context, ExploreViewModel viewModel, _) {
                switch (viewModel.response.state) {
                  case ResponseState.COMPLETE :
                    if (viewModel.response.data != null) {
                      return Center (
                        child : GridView.count(
                          crossAxisCount: 2,
                          children: List.generate(
                              viewModel.response.data!.length,
                                  (index) => _buildItemCategory(viewModel.response.data![index])
                          ),
                        ),
                      );
                    } else {
                      return _message("Categories not found");
                    }
                  case ResponseState.LOADING :
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  case ResponseState.ERROR :
                    return _message(viewModel.response.exception ?? "Unknown error");
                }
              }
          ),
        )
    );
  }

  Widget _buildItemCategory(Category category) {
    return new Center(
      child: Column(
        children: [
          FadeInImage.assetNetwork(
            placeholder: "assets/globant_placeholder.png",
            image: category.image ?? "",
            fit: BoxFit.fill,
            placeholderCacheHeight: 90,
            placeholderCacheWidth: 120,
            height: 120,
            width: 150,
          ),
          Text(
            category.name ?? "",
            maxLines: 2,
            style: Theme.of(context).textTheme.subtitle1,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _message(String? message) {
    return Center(
        child: Text(
          message ?? "",
          style: TextStyle(fontSize: 30),
          textAlign: TextAlign.center,
        )
    );
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }
}
