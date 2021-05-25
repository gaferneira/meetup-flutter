import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_meetup/model/entities/Category.dart';
import 'package:flutter_meetup/model/entities/Event.dart';
import 'package:flutter_meetup/model/repositories/CategoriesRepository.dart';
import 'package:flutter_meetup/model/repositories/EventsRepository.dart';
import 'package:flutter_meetup/viewmodel/utils/Response.dart';
import 'package:flutter_meetup/viewmodel/utils/StreamSubs.dart';

class AddEventViewModel extends ChangeNotifier {
  EventsRepository eventsRepository = EventsRepository();
  CategoriesRepository categoriesRepository = CategoriesRepository();
  StreamSubs streamSubs = StreamSubs();

  Response<DocumentReference> _addEventResponse = Response.loading();
  Response<DocumentReference> get addEventResponse => _addEventResponse;

  Response<List<Category>> _categoriesResponse = Response.loading();
  Response<List<Category>> get categoriesResponse => _categoriesResponse;

  void fetchCategories() {
    streamSubs.add(
        categoriesRepository.fetchCategories().listen((newList) {
          _categoriesResponse = Response.complete(newList);
          notifyListeners();
        })..onError((error) {
          _categoriesResponse = Response.error(error.toString());
          notifyListeners();
        })
    );
  }

  void addEvent(Event event) {
    streamSubs.add(eventsRepository.addEvent(event).asStream().listen((event) {
        _addEventResponse = Response.complete(event);
        notifyListeners();
      })..onError((error) {
        _addEventResponse = Response.error(error.toString());
        notifyListeners();
      })
    );
  }

  @override
  void dispose() {
    streamSubs.cancelAll();
    super.dispose();
  }

}
