import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_meetup/data/repositories/events_repository.dart';
import 'package:flutter_meetup/models/event.dart';
import 'package:flutter_meetup/viewmodels/utils/Response.dart';

class EventsViewModel extends ChangeNotifier {

  final EventsRepository repository;

  EventsViewModel({required this.repository});

  StreamSubscription? streamSubscription;

  Response<List<Event>> _response = Response.loading();
  Response<List<Event>> get response => _response;

  void fetchEvents({String? category}) {
    if (category == null || category.isEmpty) {
      streamSubscription = repository.fetchAllEvents().listen((newList) {
        _response = Response.complete(newList);
        notifyListeners();
      })..onError((error) {
        _response = Response.error(error.toString());
        notifyListeners();
      });
    } else {
      streamSubscription = repository.fetchAllEventsByCategory(category).listen((newList) {
        _response = Response.complete(newList);
        notifyListeners();
      })..onError((error) {
        _response = Response.error(error.toString());
        notifyListeners();
      });
    }
  }

  @override
  void dispose() {
    streamSubscription?.cancel();
    super.dispose();
  }

}
