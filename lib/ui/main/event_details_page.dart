import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meetup/constants/strings.dart';
import 'package:flutter_meetup/di/injection.dart';
import 'package:flutter_meetup/models/event.dart';
import 'package:flutter_meetup/ui/main/home/add_event_page.dart';
import 'package:flutter_meetup/utils/extension.dart';
import 'package:flutter_meetup/viewmodels/events_details_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class EventDetailsPage extends StatefulWidget {
  static const routeName = '/eventDetails';
  final Event event;

  EventDetailsPage({required this.event});

  @override
  _EventDetailsPageState createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  final key = new GlobalKey<ScaffoldState>();
  final EventsDetailsViewModel viewModel = getIt();

  @override
  void initState() {
    viewModel.event = widget.event;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EventsDetailsViewModel>.value(
      value: viewModel,
      child: Consumer(builder: (context, EventsDetailsViewModel viewModel, _) {
        return Scaffold(
          key: key,
          appBar: AppBar(
              title: Text(viewModel.event.title ?? ""),
              actions: <Widget>[
                IconButton(
                    icon: Icon(
                      viewModel.event.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      viewModel.updateFavorite(!viewModel.event.isFavorite);
                    })
              ]),
          body: ListView(children: [
            Image.network(viewModel.event.image ?? "", fit: BoxFit.fitHeight),
            Padding(
              padding: EdgeInsets.fromLTRB(24, 16, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildItem(Strings.date, viewModel.event.date),
                  _buildItem(Strings.time, viewModel.event.time),
                  _buildItem(Strings.description, viewModel.event.description),
                  _buildItem(Strings.location, viewModel.event.location),
                  _linkWidget(viewModel.event),
                  ElevatedButton(
                    child: Text(
                      (viewModel.event.isSubscribed == false)
                          ? Strings.actionSubscribe
                          : Strings.actionUnsubscribe,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    onPressed: () {
                      viewModel.updateSubscription(
                          viewModel.event.isSubscribed == false);
                    },
                  )
                ],
              ),
            )
          ]),
          floatingActionButton: (viewModel.event.isOwner == true)
              ? FloatingActionButton(
                  onPressed: () {
                    _goToEditPage();
                  },
                  tooltip: Strings.editEvent,
                  child: Icon(Icons.edit),
                )
              : null,
        );
      }),
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
                  color: Theme.of(context).textTheme.bodyText1!.color,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
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
                ),
              )
            ],
          ),
        ),
      );
    } else
      return SizedBox();
  }

  Widget _buildItem(String name, String? value) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: RichText(
          text: TextSpan(children: [
        TextSpan(
            text: "$name: ",
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyText1!.color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            )),
        TextSpan(
            text: value,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyText1!.color,
              fontSize: 16,
            ))
      ])),
    );
  }

  _goToEditPage() async {
    final result = await Navigator.of(context)
        .pushNamed(AddEventPage.routeName, arguments: viewModel.event);
    if (result is Event) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(snackBar(context, Strings.eventAddedSuccessfully));
      setState(() {
        viewModel.event = result;
      });
    }
  }
}
