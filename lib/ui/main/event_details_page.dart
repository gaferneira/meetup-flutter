import 'package:flutter/material.dart';
import 'package:flutter_meetup/models/event.dart';

class EventDetailsPage extends StatefulWidget {
  static const routeName = '/eventDetails';
  EventDetailsPage({Key? key}) : super(key: key);
  @override
  _EventDetailsPageState createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  final key = new GlobalKey<ScaffoldState>();
  Event? event;

  @override
  Widget build(BuildContext context) {
    event = ModalRoute.of(context)!.settings.arguments as Event?;
    return Scaffold(
        key: key,
        appBar: AppBar(
          title: Text("Event details"),
        ),
        body: new Center(
          child: Column(
            children: [
              Text(
                event?.title ?? "",
                style: TextStyle(fontSize: 30),
                textAlign: TextAlign.center,
              ),
              Container(
                width: double.infinity,
                height: 300,
                alignment: Alignment.center, // This is needed
                child: Image.network(event?.image ?? "",
                    fit: BoxFit.contain, width: 300),
              ),
              Text(event?.category ?? "")
            ],
          ),
        )
    );
  }
}