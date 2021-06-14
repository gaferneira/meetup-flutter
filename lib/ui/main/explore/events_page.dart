import 'package:flutter/material.dart';
import 'package:flutter_meetup/constants/strings.dart';
import 'package:flutter_meetup/di/injection.dart';
import 'package:flutter_meetup/utils/extension.dart';
import 'package:flutter_meetup/models/event.dart';
import 'package:flutter_meetup/ui/main/home/add_event_page.dart';
import 'package:flutter_meetup/viewmodels/events_viewmodel.dart';
import 'package:flutter_meetup/viewmodels/utils/Response.dart';
import 'package:flutter_meetup/widgets/search_widget.dart';
import 'package:provider/provider.dart';
import '../event_details_page.dart';

class EventsPage extends StatefulWidget {
  static final title = Strings.home;
  static const routeName = "/eventsPage";
  final String? category;

  EventsPage({Key? key, this.category}) : super(key: key);

  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final key = new GlobalKey<ScaffoldState>();
  EventsViewModel viewModel = getIt();
  Widget appBar = Text("");
  Icon actionIcon = Icon(Icons.search);
  String query = "";

  @override
  void initState() {
    appBar = Text(widget.category ?? "");
    viewModel.fetchEvents(category: widget.category);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EventsViewModel>.value(
    value: viewModel,
      child: Scaffold(
        key: key,
        appBar: AppBar(
            title: appBar,
            actions: <Widget>[
              new IconButton(icon: actionIcon, onPressed:(){
                setState(() {
                  if ( this.actionIcon.icon == Icons.search){
                    this.actionIcon = new Icon(Icons.close);
                    this.appBar = _buildSearchWidget();
                  }
                  else {
                    this.actionIcon = new Icon(Icons.search);
                    this.appBar = new Text(Strings.events);
                  }
                });
              },
              ),
            ]
        ),
        body: Consumer(
                builder: (context, EventsViewModel viewModel, _) {
                  switch (viewModel.response.state) {
                    case ResponseState.COMPLETE :
                      if (viewModel.response.data != null && viewModel.response.data!.isNotEmpty) {
                        return Column(
                          children: [
                            Expanded(
                                child: ListView(
                                  children: viewModel.response.data!.where((event) {
                                    final titleLower = event.title?.toLowerCase();
                                    final searchLower = query.toLowerCase();
                                    return query.isEmpty || (titleLower?.contains(searchLower) ?? false);
                                  }).map(_buildItem).toList(),
                                )
                            )
                          ],
                        );
                      } else {
                        return showRetry(Strings.eventsNotFound, () {
                          viewModel.fetchEvents(category: widget.category);
                        });
                      }
                    case ResponseState.LOADING :
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    default :
                      return showRetry(viewModel.response.exception, () {
                        viewModel.fetchEvents(category: widget.category);
                      });
                  }
                },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _goToAddEventPage();
          },
          tooltip: Strings.addEvent,
          child: Icon(Icons.add),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      )
    );
  }

  _goToAddEventPage() async {
    final result = await Navigator.of(context).pushNamed(AddEventPage.routeName, arguments: null);
    if (result.toString() == Strings.success)
      ScaffoldMessenger.of(context)..removeCurrentSnackBar()
        ..showSnackBar(snackBar(context, Strings.eventAddedSuccessfully));
  }

  SearchWidget _buildSearchWidget() => SearchWidget(
      text: query,
      onChanged: (value) {
        setState(() {
          query = value;
        });
      },
      hintText: Strings.searchByEventName
  );

  Widget _buildItem(Event event) {
    return  Padding(
        padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
        child: Card(
          color: Colors.white,
          child: ListTile(
            title: Text(event.title ?? ""),
            subtitle: Text("${event.date} - ${event.time}"),
            leading: AspectRatio(
              aspectRatio: 1/1,
              child: Image.network(
                event.image ?? "",
                fit: BoxFit.fitHeight,
              ),
            ),
            onTap: () {
              Navigator.of(context)
                  .pushNamed(EventDetailsPage.routeName, arguments: event);
            },
          )
        )
    );
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }
}
