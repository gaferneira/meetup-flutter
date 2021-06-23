import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_meetup/data/repositories/events_repository.dart';
import 'package:flutter_meetup/models/event.dart';

class EventsDetailsViewModel extends ChangeNotifier {

  final EventsRepository repository;

  EventsDetailsViewModel({required this.repository});

  late Event event;

  Future<bool> updateFavorite(bool add) async {

    bool response = await ((add)
        ? repository.addFavorite(event)
        : repository.removeFavorite(event));

    if (response == true) {
        event.isFavorite = add;
    }
    notifyListeners();
    return response;
  }

  Future<bool> updateSubscription(bool subscribe) async {

    bool response = await ((subscribe)
        ? repository.subscribe(event)
        : repository.unsubscribe(event));

    if (response == true) {
      event.isSubscribed = subscribe;
    }
    notifyListeners();
    return response;

  }

}
