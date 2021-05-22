import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meetup/model/entities/Event.dart';
import 'package:flutter_meetup/model/entities/Host.dart';
import 'package:flutter_meetup/viewmodel/AddEventViewModel.dart';
import 'package:provider/provider.dart';

class AddEventPage extends StatefulWidget {
  static final title = "Add Event";
  static const routeName = '/addEvent';
  AddEventPage({Key? key}) : super(key: key);
  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final key = new GlobalKey<ScaffoldState>();
  AddEventViewModel viewModel = AddEventViewModel();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddEventViewModel>.value(
    value: viewModel,
    child: Scaffold(
        key: key,
        appBar: AppBar (
          title: Text(AddEventPage.title),
        ),
        body: Container(
          margin: EdgeInsets.all(24),
          child: Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTitle(),
                  _buildDescription(),
                  _buildDate(),
                  _buildImage(),
                  _buildImageDescription(),
                  _buildCategory(),
                  _buildIsOnline(),
                  _buildLink(),
                  _buildLocation(),
                  _buildHostedBy(),
                  SizedBox(
                    height: 100,
                  ),
                  Consumer(
                    builder: (context, AddEventViewModel viewModel, _) {
                      return ElevatedButton(
                          child: Text(
                            'Submit',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          onPressed: () {
                            viewModel.addEvent(
                                Event(
                                  title: 'Evento',
                                  category: 'Have fun',
                                  date: "2020-12-02 10:00:00",
                                  description: "El evento mas esperado por toda latinoamerica unida",
                                  hostedBy: Host(
                                    name: "El Presidente",
                                    position: "Presidente del Mundo",
                                  ),
                                  image: "https://images.unsplash.com/photo-1492684223066-81342ee5ff30?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8ZXZlbnR8ZW58MHx8MHx8&ixlib=rb-1.2.1&w=1000&q=80",
                                  imageDescription: "description",
                                  isOnline: true,
                                  link: "https://images.unsplash.com/photo-1492684223066-81342ee5ff30?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8ZXZlbnR8ZW58MHx8MHx8&ixlib=rb-1.2.1&w=1000&q=80",
                                  location: "",
                                )
                            );
                          }
                      );
                    }
                  )
                ],
              ),
          ),
        )
    )
    );
  }


  Widget _buildCategory() {
    return Center();
  }

  Widget _buildDate() {
    return Center();
  }

  Widget _buildDescription() {
    return Center();
  }

  Widget _buildImage() {
    return Center();
  }

  Widget _buildImageDescription() {
    return Center();
  }

  Widget _buildIsOnline() {
    return Center();
  }

  Widget _buildLink() {
    return Center();
  }

  Widget _buildLocation() {
    return Center();
  }

  Widget _buildTitle() {
    return Center();
  }

  Widget _buildHostedBy() {
    return Center();
  }

}