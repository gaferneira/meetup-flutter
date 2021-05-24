import 'package:flutter/material.dart';
import 'package:flutter_meetup/model/entities/Event.dart';
import 'package:flutter_meetup/view/pages/AddEventPage.dart';
import 'package:flutter_meetup/viewmodel/HomeViewModel.dart';
import 'package:flutter_meetup/viewmodel/utils/Response.dart';
import 'package:provider/provider.dart';
import 'EventDetailsPage.dart';

class HomePage extends StatefulWidget {
  static final title = "Home";

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
                        return _message("Events not found");
                      }
                    case ResponseState.LOADING :
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    case ResponseState.ERROR :
                      return _message(viewModel.response.exception ?? "Unknown error");
                  }
                },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .pushNamed(AddEventPage.routeName);
          },
          tooltip: 'Add Event',
          child: Icon(Icons.add),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      )
    );
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

  Widget _message(String? message) {
    return Center(
        child: Text(
          message ?? "",
          style: TextStyle(fontSize: 30),
          textAlign: TextAlign.center,
        )
    );
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }
}