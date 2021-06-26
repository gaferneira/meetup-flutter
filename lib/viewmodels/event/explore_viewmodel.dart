import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_meetup/data/repositories/categories_respository.dart';
import 'package:flutter_meetup/models/category.dart';
import 'package:flutter_meetup/viewmodels/utils/Response.dart';

class ExploreViewModel extends ChangeNotifier {

  final CategoriesRepository repository;

  ExploreViewModel({required this.repository});

  StreamSubscription? streamSubscription;

  Response<List<Category>> _response = Response.loading();

  Response<List<Category>> get response => _response;

  void fetchCategories() {
    streamSubscription = repository.fetchCategories().listen((newList) {
      _response = Response.complete(newList);
      notifyListeners();
    })..onError((error) {
      _response = Response.error(error.toString());
      notifyListeners();
    });
  }

  @override
  void dispose() {
    streamSubscription?.cancel();
    super.dispose();
  }

}
