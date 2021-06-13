import 'dart:io';

import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_meetup/constants/strings.dart';
import 'package:flutter_meetup/data/repositories/categories_respository.dart';
import 'package:flutter_meetup/data/repositories/events_repository.dart';
import 'package:flutter_meetup/data/repositories/locations_repository.dart';
import 'package:flutter_meetup/di/injection.dart';
import 'package:flutter_meetup/models/drop_down_item.dart';
import 'package:flutter_meetup/models/event.dart';
import 'package:flutter_meetup/viewmodels/utils/Response.dart';
import 'package:flutter_meetup/viewmodels/utils/StreamSubs.dart';

class AddEventViewModel extends ChangeNotifier {

  final EventsRepository eventsRepository;
  final CategoriesRepository categoriesRepository;
  final LocationsRepository locationsRepository;

  AddEventViewModel({required this.eventsRepository, required this.categoriesRepository,
      required this.locationsRepository});

  StreamSubs streamSubs = StreamSubs();

  Response<List<List<DropDownItem>>> _dataResponse = Response.none();
  Response<List<List<DropDownItem>>> get dataResponse => _dataResponse;

  Response<DocumentReference> _addEventResponse = Response.none();
  Response<DocumentReference> get addEventResponse => _addEventResponse;

  Response<String> _imageResponse = Response.none();
  Response<String> get imageResponse => _imageResponse;

  void fetchData() {
    _dataResponse = Response.loading();
    notifyListeners();
    streamSubs.add(
        StreamZip([
          locationsRepository.fetchLocations(),
          categoriesRepository.fetchCategories(),
        ]).listen((data) {
          _dataResponse = Response.complete(data);
          notifyListeners();
        })..onError((error) {
          _dataResponse = Response.error(error.toString());
          notifyListeners();
        })
    );
  }

  uploadImage(File file) {
    _imageResponse = Response.loading();
    notifyListeners();
    streamSubs.add(eventsRepository.uploadImage(file).listen((snapshot) {
      getImageUrl(snapshot);
    })..onError((error) {
      _imageResponse = Response.error(error.toString());
      notifyListeners();
    }));
  }

  getImageUrl(TaskSnapshot snapshot) async {
    var downloadUrl = await snapshot.ref.getDownloadURL();
    _imageResponse = Response.complete(downloadUrl);
    notifyListeners();
  }

  Future<Response<bool>> addEvent(Event event) async {
    if (event.image == null || event.image!.isEmpty) {
      return Response.error("Please add an image for the Event");
    }

    try {
      await eventsRepository.addEvent(event);
      return Response.complete(true);
    } catch (error) {
      return Response.error(error.toString());
    }
  }

  @override
  void dispose() {
    streamSubs.cancelAll();
    super.dispose();
  }

}