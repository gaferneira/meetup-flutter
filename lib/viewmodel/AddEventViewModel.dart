import 'dart:io';

import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_meetup/model/entities/Event.dart';
import 'package:flutter_meetup/model/repositories/CategoriesRepository.dart';
import 'package:flutter_meetup/model/repositories/EventsRepository.dart';
import 'package:flutter_meetup/model/repositories/LocationsRepository.dart';
import 'package:flutter_meetup/view/customwidgets/DropDownItem.dart';
import 'package:flutter_meetup/viewmodel/utils/Response.dart';
import 'package:flutter_meetup/viewmodel/utils/StreamSubs.dart';

class AddEventViewModel extends ChangeNotifier {
  EventsRepository eventsRepository = EventsRepository();
  CategoriesRepository categoriesRepository = CategoriesRepository();
  LocationsRepository locationsRepository = LocationsRepository();
  StreamSubs streamSubs = StreamSubs();

  Response<DocumentReference> _addEventResponse = Response.loading();
  Response<DocumentReference> get addEventResponse => _addEventResponse;

  Response<List<List<DropDownItem>>> _dataResponse = Response.loading();
  Response<List<List<DropDownItem>>> get dataResponse => _dataResponse;

  Response<String> _imageResponse = Response.loading();
  Response<String> get imageResponse => _imageResponse;

  void fetchData() {
    streamSubs.add(
        StreamZip([
          locationsRepository.fetchLocations(),
          categoriesRepository.fetchCategories(),
        ]).listen((data) {
          _dataResponse = Response.complete(data);
          notifyListeners();
        })
    );
  }

  uploadImage(File file) {
    streamSubs.add(eventsRepository.uploadImage(file).listen((snapshot) {
      getImageUrl(snapshot);
    }));
  }

  getImageUrl(TaskSnapshot snapshot) async {
    var downloadUrl = await snapshot.ref.getDownloadURL();
    _imageResponse = Response.complete(downloadUrl);
    notifyListeners();
  }

  void addEvent(Event event) {
    streamSubs.add(eventsRepository.addEvent(event).listen((event) {
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
