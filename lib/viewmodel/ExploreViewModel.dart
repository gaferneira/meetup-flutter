import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_meetup/model/entities/Category.dart';
import 'package:flutter_meetup/model/repositories/CategoriesRepository.dart';
import 'package:flutter_meetup/viewmodel/utils/Reponse.dart';

class ExploreViewModel extends ChangeNotifier {
  CategoriesRepository repository = CategoriesRepository();
  StreamSubscription? streamSubscription;

  Response<List<Category>> _response = Response.loading();

  Response<List<Category>> get response => _response;

  void fetchCategories() {
    streamSubscription = repository.fetchCategories().listen((newList) {
      _response = Response.complete(newList);
      notifyListeners();
    })..onError((error) {
      _response = Response.error(error);
      notifyListeners();
    });
  }

  @override
  void dispose() {
    streamSubscription?.cancel();
    super.dispose();
  }

}
