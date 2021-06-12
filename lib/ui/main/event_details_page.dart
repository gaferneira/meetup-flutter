import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meetup/constants/strings.dart';
import 'package:flutter_meetup/models/event.dart';
import 'package:url_launcher/url_launcher.dart';

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
          title: Text(event?.title ?? ""),
        ),
        body: ListView(
            children: [
              Image.network(
                  event?.image ?? "",
                  fit: BoxFit.fill,
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text("Fecha: ${event?.date}"),
                    Text("Hora: ${event?.time}"),
                    Text("Descripcion: ${event?.description}"),
                    Text("Lugar: ${event?.location}"),
                    _linkWidget(event)
                  ],
                ),
              )
            ],
        )
    );
  }

  Widget _linkWidget(Event? event) {
    if (event != null && (event.isOnline ?? false) && event.link != null && event.link!.isNotEmpty) {
      return RichText(
        text: TextSpan(
            children: [
              TextSpan(
                  text: "${Strings.LINK}: ",
                  style: TextStyle(
                      color: Colors.black
                  )
              ),
              TextSpan(
                  text: event.link,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      launch(event.link!);
                    },
                  style: TextStyle(
                      color: Colors.blueAccent
                  )
              )
            ]
        )
      );
    } else return SizedBox();
  }
}
