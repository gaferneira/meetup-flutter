import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_meetup/data/entities/Event.dart';

import '../../data/repositories/EventsRepository.dart';
import '../detail/EventDetailsPage.dart';

class HomePage extends StatefulWidget {
  static final title = "Home";

  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  EventsRepository eventsRepository = EventsRepository();
  StreamSubscription? streamSubscription;

  List<Event> events = [];

  @override
  void initState() {
    streamSubscription = eventsRepository.fetchAllEvents().listen((newList) {
      setState(() {
        events = newList;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final key = new GlobalKey<ScaffoldState>();
    return Scaffold(
      key: key,
      appBar: AppBar(
        title: Text("Event list"),
      ),
      body: new ListView(
        children: events.map(_buildItem).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          key.currentState!.showSnackBar(new SnackBar(
            content: new Text("//TODO Implement"),
          ));
        },
        tooltip: 'Add Event',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _buildItem(Event event) {
    return new ListTile(
      title: new Text(event.title ?? ""),
      subtitle: new Text('Category: ${event.category}'),
      leading: Image.network(event.imageDescription ?? ""),
      onTap: () {
        Navigator.of(context)
            .pushNamed(EventDetailsPage.routeName, arguments: event);
      },
    );
  }

  @override
  void dispose() {
    streamSubscription?.cancel();
    super.dispose();
  }
}
