import 'package:flutter/material.dart';
import 'package:flutter_meetup/constants/strings.dart';
import 'package:flutter_meetup/utils/extension.dart';
import 'package:flutter_meetup/models/event.dart';
import 'package:flutter_meetup/ui/main/home/add_event_page.dart';
import 'package:flutter_meetup/viewmodels/home_viewmodel.dart';
import 'package:flutter_meetup/viewmodels/utils/Response.dart';
import 'package:provider/provider.dart';
import '../event_details_page.dart';

class HomePage extends StatefulWidget {
  static final title = Strings.home;

  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final key = new GlobalKey<ScaffoldState>();
  HomeViewModel viewModel = HomeViewModel();

  @override
  void initState() {
    viewModel.fetchEvents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeViewModel>.value(
    value: viewModel,
      child: Scaffold(
        key: key,
        appBar: AppBar(
          title: Text("Event list"),
        ),
        body: Consumer(
                builder: (context, HomeViewModel viewModel, _) {
                  switch (viewModel.response.state) {
                    case ResponseState.COMPLETE :
                      if (viewModel.response.data != null) {
                        return ListView(
                          children: viewModel.response.data!.map(_buildItem).toList(),
                        );
                      } else {
                        return showRetry("Events not found.", () {
                          viewModel.fetchEvents();
                        });
                      }
                    case ResponseState.LOADING :
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    default :
                      return showRetry(viewModel.response.exception, () {
                        viewModel.fetchEvents();
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
    final result = await Navigator.of(context).pushNamed(AddEventPage.routeName);
    if (result.toString() == Strings.success)
      ScaffoldMessenger.of(context)..removeCurrentSnackBar()
        ..showSnackBar(snackBar(context, Strings.eventAddedSuccessfully));
  }

  Widget _buildItem(Event event) {
    return new ListTile(
      title: new Text(event.title ?? ""),
      subtitle: new Text('Category: ${event.category}'),
      leading: Image.network(event.image ?? ""),
      onTap: () {
        Navigator.of(context)
            .pushNamed(EventDetailsPage.routeName, arguments: event);
      },
    );
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }
}
