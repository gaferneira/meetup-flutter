import 'package:flutter/material.dart';
import 'package:flutter_meetup/constants/assets.dart';
import 'package:flutter_meetup/constants/dimens.dart';
import 'package:flutter_meetup/constants/strings.dart';
import 'package:flutter_meetup/di/injection.dart';
import 'package:flutter_meetup/utils/extension.dart';
import 'package:flutter_meetup/models/event.dart';
import 'package:flutter_meetup/ui/main/home/add_event_page.dart';
import 'package:flutter_meetup/viewmodels/home/home_data.dart';
import 'package:flutter_meetup/viewmodels/home/home_viewmodel.dart';
import 'package:flutter_meetup/viewmodels/utils/Response.dart';
import 'package:provider/provider.dart';
import '../event_details_page.dart';

class HomePage extends StatefulWidget {
  static final title = Strings.home;

  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final key = new GlobalKey<ScaffoldState>();
  HomeViewModel viewModel =  getIt();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    viewModel.fetchEvents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ChangeNotifierProvider<HomeViewModel>.value(
        value: viewModel,
        child: Scaffold(
          key: key,
          appBar: AppBar(
            title: Text(HomePage.title),
          ),
          body: Consumer(builder: (context, HomeViewModel viewModel, _) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  _myEventsView(viewModel.response),
                  _divider(Dimens.DIVIDER_NORMAL),
                  _calendarView(viewModel.response, this)
                ],
              ),
            );
          }),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _goToAddEventPage();
            },
            tooltip: Strings.addEvent,
            child: Icon(Icons.add),
          ), // This trailing comma makes auto-formatting nicer for build methods.
        ));
  }

  _goToAddEventPage() async {
    final result =
        await Navigator.of(context).pushNamed(AddEventPage.routeName);
    if (result.toString() == Strings.success)
      ScaffoldMessenger.of(context)..removeCurrentSnackBar()
        ..showSnackBar(snackBar(context, Strings.eventAddedSuccessfully));
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  Widget _myEventsView(Response<HomeData> response) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(Strings.myEvents,
                style: Theme.of(context).textTheme.headline6),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                //Go to my events list
              },
              child: Text(""),
            ),
          )
        ]),
        Container(
          width: double.infinity,
          height: 160.0,
          child: Builder(builder: (BuildContext context) {
            switch (viewModel.response.state) {
              case ResponseState.COMPLETE:
                if (viewModel.response.data != null) {
                  return ListView(
                    scrollDirection: Axis.horizontal,
                    children: viewModel.response.data!.myEvents
                        .map(_buildMyEventsItem)
                        .toList(),
                  );
                } else {
                  return Text(Strings.eventsNotFound);
                }
              case ResponseState.LOADING:
                return Center(
                  child: CircularProgressIndicator(),
                );
              default:
                return showRetry(context, viewModel.response.exception, () {
                  viewModel.fetchEvents();
                });
            }
          }),
        ),
      ]),
    );
  }

  Widget _buildMyEventsItem(Event event) {
    return Container(
        width: 120,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .pushNamed(EventDetailsPage.routeName, arguments: event);
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Stack(
                children: [
                  FadeInImage.assetNetwork(
                    placeholder: Assets.placeHolder,
                    image: event.image ?? "",
                    fit: BoxFit.fitHeight,
                    height: double.infinity,
                    width: double.infinity,
                  ),
                  Align(
                      alignment: Alignment.bottomLeft,
                      child: Stack(
                        children: [
                          ShaderMask(
                            shaderCallback: (rect) {
                              return LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [Colors.grey, Colors.transparent],
                              ).createShader(
                                  Rect.fromLTRB(0, 0, rect.width, rect.height));
                            },
                            child: Container(
                              color: Colors.black54,
                              height: 32.0,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 8, top: 8),
                            child: Text(
                              event.title ?? "",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          )
                        ],
                      )),
                ],
              ),
            ),
          ),
        ));
  }

  Widget _calendarView(Response<HomeData> response, TickerProvider tickerProvider) {
    // Create TabController for getting the index of current tab
    var _controller = TabController(length: 4, vsync: tickerProvider);

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(children: [
        Row(children: [
          Text(Strings.homeCalendar,
              style: Theme.of(context).textTheme.headline6)
        ]),
        TabBar(
          controller: _controller,
          tabs: [
            Tab(text: Strings.homeCalendarOptionAll),
            Tab(text: Strings.homeCalendarOptionGoing),
            Tab(text: Strings.homeCalendarOptionSaved),
            Tab(text: Strings.homeCalendarOptionPast),
          ],
          indicator: UnderlineTabIndicator(borderSide: BorderSide(width: 1.0)),
        ),
        Container(
          width: double.infinity,
          height: 300.0,
          child: Builder(builder: (BuildContext context) {
            switch (viewModel.response.state) {
              case ResponseState.COMPLETE:
                  return TabBarView(controller: _controller, children: [
                    _calendarList(viewModel.response.data?.comingEvents),
                    _calendarList(viewModel.response.data?.goingEvents),
                    _calendarList(viewModel.response.data?.savedEvents),
                    _calendarList(viewModel.response.data?.pastEvents)
                  ]);
              case ResponseState.LOADING:
                return Center(
                  child: CircularProgressIndicator(),
                );
              default:
                return showRetry(context, viewModel.response.exception, () {
                  viewModel.fetchEvents();
                });
            }
          }),
        ),
      ]),
    );
  }

  Widget _buildItem(Event event) {
    return new ListTile(
      title: new Text(event.title ?? ""),
      subtitle: new Text('${Strings.category}: ${event.category}'),
      leading: Container(
          width: 80,
          height: 80,
          child: Image.network(event.image ?? "", fit: BoxFit.fitWidth)),
      onTap: () {
        Navigator.of(context)
            .pushNamed(EventDetailsPage.routeName, arguments: event);
      },
    );
  }

  Widget _divider(double height) {
    return Container(
      width: double.infinity,
      height: height,
      color: Theme.of(context).dividerColor,
    );
  }

  Widget _calendarList(List<Event>? list) {
    if (list?.isNotEmpty == true) {
      return ListView(
        children: list!.map(_buildItem).toList(),
      );
    } else {
      return Center(
        child: Text(Strings.eventsNotFound,
            style: Theme.of(context).textTheme.headline6),
      );
    }
  }
}
