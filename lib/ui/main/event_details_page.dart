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
                padding: EdgeInsets.fromLTRB(24, 16, 24, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildItem(Strings.DATE, event?.date),
                    _buildItem(Strings.TIME, event?.time),
                    _buildItem(Strings.DESCRIPTION, event?.description),
                    _buildItem(Strings.LOCATION, event?.location),
                    _linkWidget(event)
                  ],
                ),
              )
            ],
        )
    );
  }

  Widget _linkWidget(Event? event) {
    if (event != null && event.link != null && event.link!.isNotEmpty) {
      return Padding(
        padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
        child: RichText(
            text: TextSpan(
                children: [
                  TextSpan(
                      text: "${Strings.LINK}: ",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      )
                  ),
                  TextSpan(
                      text: event.link,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          launch(event.link!);
                        },
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 16,
                      )
                  )
                ]
            )
        ),
      );
    } else return SizedBox();
  }

  Widget _buildItem(String name, String? value) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: RichText(
          text: TextSpan(
              children: [
                TextSpan(
                    text: "$name: ",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    )
                ),
                TextSpan(
                    text: value,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    )
                )
              ]
          )
      ),
    );
  }
}
