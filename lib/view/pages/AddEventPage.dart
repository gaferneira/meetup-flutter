import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meetup/model/entities/Category.dart';
import 'package:flutter_meetup/model/entities/Event.dart';
import 'package:flutter_meetup/viewmodel/AddEventViewModel.dart';
import 'package:flutter_meetup/viewmodel/utils/Response.dart';
import 'package:provider/provider.dart';

class AddEventPage extends StatefulWidget {
  static final title = "Add Event";
  static const routeName = '/addEvent';
  AddEventPage({Key? key}) : super(key: key);
  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final key = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  Event _event = Event();
  AddEventViewModel viewModel = AddEventViewModel();
  String _chosenValue = "";

  @override
  void initState() {
    viewModel.fetchCategories();
    super.initState();
  }

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
          child: Consumer(
          builder: (context, AddEventViewModel viewModel, _) {
            switch (viewModel.categoriesResponse.state) {
              case ResponseState.COMPLETE : {
                return Form(
                  key: _formKey,
                  child: ListView (
                    children: [
                      _buildInputText('Title', 'Title is required', (value) => {_event.title = value}),
                      _buildInputText('Description', 'Description is required', (value) => {_event.description = value}),
                      _buildInputText('Date', 'Date is required', (value) => {_event.date = value}),
                      _buildInputText('Image', 'Image is required', (value) => {_event.image = value}),
                      _buildInputText('Image Description', 'Image Description is required', (value) => {_event.imageDescription = value}),
                      //_buildInputText('IsOnLine', 'IsOnLine is required', (value) => {_event.isOnline = value}),
                      _buildInputText('Link', 'Link is required', (value) => {_event.link = value}),
                      _buildInputText('Location', 'Location is required', (value) => {_event.location = value}),
                      _buildDropDownButton(viewModel.categoriesResponse.data),
                      //_buildHostedBy(),
                      ElevatedButton(
                          child: Text(
                            'Submit',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          onPressed: () {
                            if (!(_formKey.currentState?.validate() ?? false)) return;
                            _formKey.currentState?.save();
                            viewModel.addEvent(_event);
                          }
                      )
                    ],
                  ),
                );
              }
              case ResponseState.LOADING :
                return Center(
                  child: CircularProgressIndicator(),
                );
              case ResponseState.ERROR :
                return _message(viewModel.categoriesResponse.exception ?? "Unknown error");
            }
          }
          )
        )
    )
    );
  }

  Widget _buildInputText(String labelText, String errorText, Function(String?) callback) {
    return TextFormField(
      decoration: InputDecoration(
          labelText: labelText,
      ),
      validator: (value) {
        if (value?.isEmpty ?? false) {
          return errorText;
        }
      },
      onSaved: (value) {
        callback(value);
      },
    );
  }

  Widget _buildDropDownButton(List<Category>? categories) {
    return Center();
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

}