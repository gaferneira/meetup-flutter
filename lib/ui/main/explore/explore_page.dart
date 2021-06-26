import 'package:flutter/material.dart';
import 'package:flutter_meetup/constants/assets.dart';
import 'package:flutter_meetup/constants/strings.dart';
import 'package:flutter_meetup/di/injection.dart';
import 'package:flutter_meetup/ui/main/explore/events_page.dart';
import 'package:flutter_meetup/utils/extension.dart';
import 'package:flutter_meetup/viewmodels/event/explore_viewmodel.dart';
import 'package:flutter_meetup/viewmodels/utils/Response.dart';
import 'package:provider/provider.dart';
import '../../../models/category.dart';

class ExplorePage extends StatefulWidget {
  static final title = Strings.explore;

  @override
  State<StatefulWidget> createState() {
    return _CategoriesPage();
  }
}

class _CategoriesPage extends State<ExplorePage> with AutomaticKeepAliveClientMixin {
  final key = new GlobalKey<ScaffoldState>();
  ExploreViewModel viewModel = getIt();


  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    viewModel.fetchCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      key: key,
      appBar: AppBar(
        title: Text(ExplorePage.title),
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
                    return showRetry(context, Strings.categoriesNotFound, () {
                      viewModel.fetchCategories();
                    });
                  }
                case ResponseState.LOADING :
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                default :
                  return showRetry(context, viewModel.response.exception ?? Strings.unknownError, () {
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
                fit: BoxFit.fitHeight,
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

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }
}
