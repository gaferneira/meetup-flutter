import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_meetup/data/repositories/categories_respository.dart';
import 'package:flutter_meetup/data/repositories/events_repository.dart';
import 'package:flutter_meetup/data/repositories/locations_repository.dart';
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

  Future<Response<bool>> addEventAndImage(Event event, File? file) async {
    try {
      if (file != null) {
        var snapshot = await eventsRepository.uploadImage(file);
        event.image = await snapshot.ref.getDownloadURL();
      }
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