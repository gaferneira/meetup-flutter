import 'package:flutter_meetup/models/event.dart';

class HomeData {
  List<Event> myEvents;
  List<Event> comingEvents;
  List<Event> goingEvents;
  List<Event> savedEvents;
  List<Event> pastEvents;

  HomeData(
      {required this.myEvents,
      required this.comingEvents,
      required this.goingEvents,
      required this.savedEvents,
      required this.pastEvents});
}
