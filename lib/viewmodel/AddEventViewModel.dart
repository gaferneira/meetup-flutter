import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_meetup/model/entities/Event.dart';
import 'package:flutter_meetup/model/repositories/EventsRepository.dart';
import 'package:flutter_meetup/viewmodel/utils/Response.dart';

class AddEventViewModel extends ChangeNotifier {
  EventsRepository repository = EventsRepository();
  StreamSubscription? streamSubscription;

  Response<DocumentReference> _response = Response.loading();
  Response<DocumentReference> get response => _response;

  void addEvent(Event event) {
    streamSubscription = repository.addEvent(event).asStream().listen((event) {
        _response = Response.complete(event);
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
