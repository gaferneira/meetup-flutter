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
                        childAspectRatio: (2 / 2),
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        padding: EdgeInsets.all(10.0),
                        children: List.generate(
                            viewModel.response.data!.length,
                                (index) => _buildCategoryItem(viewModel.response.data![index])
                        ),
                      ),
                    );
                  } else {
                    return showRetry(Strings.CATEGORIES_NOT_FOUND, () {
                      viewModel.fetchCategories();
                    });
                  }
                case ResponseState.LOADING :
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                default :
                  return showRetry(viewModel.response.exception ?? Strings.UNKNOWN_ERROR, () {
                    viewModel.fetchCategories();
                  });
              }
            }
          ),
        )
    );
  }

  Widget _buildCategoryItem(Category category) {
    return Container(
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => EventsPage(category: category.name)
          ));
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Stack(
            children: [
              FadeInImage.assetNetwork(
                placeholder: Assets.placeHolder,
                image: category.image ?? "",
                fit: BoxFit.fill,
                height: double.infinity,
                width: double.infinity,
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Stack(children: [
                  ShaderMask(
                    shaderCallback: (rect) {
                      return LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Colors.grey, Colors.transparent],
                      ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
                      },
                    child: Container(
                      color: Colors.black54,
                      height: 32.0,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8, top: 8),
                    child: Text(
                      category.name ?? "",
                      maxLines: 2,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  )
                ],
              )
              ),
            ],
          ),
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

  Widget showRetry(String message, Function() onPressed) {
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                message,
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              ElevatedButton(
                onPressed: onPressed,
                child: Text(Strings.RETRY),
              )
            ]
        )
    );
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }
}
