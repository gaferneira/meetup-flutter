
import 'package:flutter_meetup/models/event.dart';


class HomeData {
  List<Event> myEvents;
  List<Event> comingEvents;
  List<Event> goingEvents;
  List<Event> savedEvents;
  List<Event> pastEvents;

  HomeData(this.myEvents, this.comingEvents, this.goingEvents, this.savedEvents,
      this.pastEvents);
}