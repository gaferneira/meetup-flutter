import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meetup/constants/strings.dart';
import 'package:flutter_meetup/models/event.dart';
import 'package:flutter_meetup/ui/main/home/add_event_page.dart';
import 'package:flutter_meetup/utils/extension.dart';
import 'package:url_launcher/url_launcher.dart';

class EventDetailsPage extends StatefulWidget {
  static const routeName = '/eventDetails';
  final Event? event;

  EventDetailsPage([this.event]);

  @override
  _EventDetailsPageState createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  final key = new GlobalKey<ScaffoldState>();
  Event? _event;

  @override
  void initState() {
    _event = widget.event;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: key,
        appBar: AppBar(
          title: Text(_event?.title ?? ""),
        ),
        body: ListView(
            children: [
              Image.network(
                  _event?.image ?? "",
                  fit: BoxFit.fitHeight
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(24, 16, 24, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildItem(Strings.date, _event?.date),
                    _buildItem(Strings.time, _event?.time),
                    _buildItem(Strings.description, _event?.description),
                    _buildItem(Strings.location, _event?.location),
                    _linkWidget(_event)
                  ],
                ),
              )
            ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _goToEditPage();
          },
          tooltip: Strings.editEvent,
          child: Icon(Icons.edit),
        ),
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
                      text: "${Strings.link}: ",
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

  _goToEditPage() async {
    final result =
        await Navigator.of(context).pushNamed(AddEventPage.routeName, arguments: _event);
    if (result.toString() == Strings.success)
      ScaffoldMessenger.of(context)..removeCurrentSnackBar()
        ..showSnackBar(snackBar(context, Strings.eventAddedSuccessfully));
  }
}
