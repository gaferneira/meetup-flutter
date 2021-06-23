import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_meetup/data/repositories/events_repository.dart';
import 'package:flutter_meetup/models/event.dart';
import 'package:flutter_meetup/viewmodels/home/home_data.dart';
import 'package:flutter_meetup/viewmodels/utils/Response.dart';

class HomeViewModel extends ChangeNotifier {

  EventsRepository repository;

  HomeViewModel({required this.repository});

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

    List<Event> comingEvents = [];
    List<Event> pastEvents = [];

    List<Event> savedEvents = [];
    List<Event> goingEvents = [];

    List<Event> myEvents = [];

    var now = DateTime.now();

    list.forEach((event) {
      var eventDate = event.when?.toDate();
      if (eventDate == null || eventDate.compareTo(now) >= 0) {
        comingEvents.add(event);
      } else {
        pastEvents.add(event);
      }

      if (event.isSubscribed) {
        goingEvents.add(event);
      }

      if (event.isFavorite) {
        savedEvents.add(event);
      }

      if (event.isOwner) {
        myEvents.add(event);
      }

    });


    return HomeData(
        myEvents: myEvents,
        comingEvents : comingEvents,
        pastEvents : pastEvents,
        savedEvents : savedEvents,
        goingEvents : goingEvents);
  }

  @override
  void dispose() {
    streamSubscription?.cancel();
    super.dispose();
  }

}
