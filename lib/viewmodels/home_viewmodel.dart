import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_meetup/data/repositories/events_repository.dart';
import 'package:flutter_meetup/models/event.dart';
import 'package:flutter_meetup/viewmodels/utils/Response.dart';

class HomeViewModel extends ChangeNotifier {
  EventsRepository repository = EventsRepository();
  StreamSubscription? streamSubscription;

  Response<List<Event>> _response = Response.loading();
  Response<List<Event>> get response => _response;

  void fetchEvents() {
    streamSubscription = repository.fetchAllEvents().listen((newList) {
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