import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_meetup/data/repositories/events_repository.dart';
import 'package:flutter_meetup/di/injection.dart';
import 'package:flutter_meetup/models/event.dart';
import 'package:flutter_meetup/viewmodels/home/home_data.dart';
import 'package:flutter_meetup/viewmodels/utils/Response.dart';

class HomeViewModel extends ChangeNotifier {
  EventsRepository repository = getIt();
  StreamSubscription? streamSubscription;

  Response<HomeData> _response = Response.loading();
  Response<HomeData> get response => _response;

  void fetchEvents() {
    streamSubscription = repository.fetchAllEvents().listen((newList) {
      _response = Response.complete(_manageResponse(newList));
      notifyListeners();
    })..onError((error) {
      _response = Response.error(error.toString());
      notifyListeners();
    });
  }

  HomeData _manageResponse(List<Event> list) {
    return HomeData(
      list,
      list,
      list,
      list,
      list
    );
  }

  @override
  void dispose() {
    streamSubscription?.cancel();
    super.dispose();
  }

}
