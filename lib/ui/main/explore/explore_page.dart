import 'package:flutter/material.dart';
import 'package:flutter_meetup/constants/assets.dart';
import 'package:flutter_meetup/constants/strings.dart';
import 'package:flutter_meetup/ui/main/explore/events_page.dart';
import 'package:flutter_meetup/viewmodels/explore_viewmodel.dart';
import 'package:flutter_meetup/viewmodels/utils/Response.dart';
import 'package:provider/provider.dart';
import '../../../models/category.dart';

class ExplorePage extends StatefulWidget {
  static final title = "Explore";

  ExplorePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CategoriesPage();
  }
}

class _CategoriesPage extends State<ExplorePage> {
  final key = new GlobalKey<ScaffoldState>();
  ExploreViewModel viewModel = ExploreViewModel();

  @override
  void initState() {
    viewModel.fetchCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
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
                                (index) => _buildCategoryItem(viewModel.response.data![index])
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
                default :
                  return _message(viewModel.response.exception ?? Strings.UNKNOWN_ERROR);
              }
            }
          ),
        )
    );
  }

  Widget _buildCategoryItem(Category category) {
    return new Center(
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => EventsPage(category: category.name)
          ));
        },
        child: Column(
          children: [
            FadeInImage.assetNetwork(
              placeholder: Assets.placeHolder,
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
      )
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
