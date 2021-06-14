import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meetup/constants/strings.dart';
import 'package:flutter_meetup/di/injection.dart';
import 'package:flutter_meetup/models/category.dart';
import 'package:flutter_meetup/models/event.dart';
import 'package:flutter_meetup/models/location.dart';
import 'package:flutter_meetup/utils/extension.dart';
import 'package:flutter_meetup/models/drop_down_item.dart';
import 'package:flutter_meetup/utils/file_reader.dart';
import 'package:flutter_meetup/viewmodels/add_event_viewmodel.dart';
import 'package:flutter_meetup/viewmodels/utils/Response.dart';
import 'package:flutter_meetup/widgets/image_picker_widget.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:provider/provider.dart';

class AddEventPage extends StatefulWidget {
  static const routeName = '/addEvent';
  final Event? event;

  AddEventPage([this.event]);

  @override
  State<StatefulWidget> createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  final _formKey = GlobalKey<FormState>();
  final AddEventViewModel viewModel = getIt();
  Event _event = Event();
  ImagePath? _imagePath;
  bool _isUpdate = false;
  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();
  ImagePickerWidget? imagePickerWidget;

  @override
  void initState() {
    if (widget.event != null) {
      _event.documentId = widget.event!.documentId;
      _event.title = widget.event!.title;
      _event.image = widget.event!.image;
      _event.category = widget.event!.category;
      _event.location = widget.event!.location;
      _event.link = widget.event!.link;
      _event.time = widget.event!.time;
      _event.date = widget.event!.date;
      _event.description = widget.event!.description;
      _isUpdate = true;
      _imagePath = ImagePath(false, _event.image);
    }
    imagePickerWidget = ImagePickerWidget((image) {
        setState(() {
          _imagePath = image;
        });
      }, () {
        scaffoldMessengerKey.currentState?.showSnackBar(
          snackBar(context, Strings.imageUploadFailed, true));
      }, () {
        scaffoldMessengerKey.currentState?.showSnackBar(
          snackBar(context, Strings.pleaseGrantPermissions, true));
      }
    );
    viewModel.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddEventViewModel>.value(
      value: viewModel,
      child: ScaffoldMessenger(
        key: scaffoldMessengerKey,
        child: Scaffold(
            key: widget.key,
            appBar: AppBar (
              title: Text(_isUpdate ? Strings.editEvent : Strings.addEvent),
            ),
            body: Container(
                margin: EdgeInsets.fromLTRB(24, 0, 24, 0),
                child: Consumer(
                    builder: (context, AddEventViewModel viewModel, _) {
                      switch (viewModel.dataResponse.state) {
                        case ResponseState.COMPLETE : {
                          return Form(
                            key: _formKey,
                            child: ListView (
                              children: [
                                _buildInputText(Strings.title, Strings.titleRequired, (value) => {_event.title = value}, _event.title),
                                _buildInputText(Strings.description, Strings.descriptionRequired, (value) => {_event.description = value}, _event.description),
                                _buildDatePickerText(context, (value) => {_event.date = value}, _event.date),
                                _buildTimePickerText(context, (value) => {_event.time = value}, _event.time),
                                _buildInputText(Strings.link, null, (value) => {_event.link = value}, _event.link),
                                _buildDropDown(viewModel.dataResponse.data?[0] as List<Location>, (value) => {_event.location = value}, _event.location),
                                _buildDropDown(viewModel.dataResponse.data?[1] as List<Category>, (value) => {_event.category = value}, _event.category),
                                imagePickerWidget!.buildImagePickerWidget(_imagePath),
                                ElevatedButton(
                                    child: Text(
                                      Strings.submit,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                    onPressed: () {
                                      _validateAndSubmit();
                                    },
                                )
                              ],
                            ),
                          );
                        }
                        case ResponseState.LOADING :
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                          default :
                            return showRetry(viewModel.dataResponse.exception, (){
                              viewModel.fetchData();
                            });
                      }
                    }
                )
            )
        )
      )
    );
  }

  Widget _buildInputText(String labelText, String? errorText, Function(String?) callback, String? initialValue) {
    return TextFormField(
      decoration: InputDecoration(
          labelText: labelText,
      ),
      validator: (value) {
        if (errorText != null && (value?.isEmpty ?? false)) {
          return errorText;
        }
      },
      onSaved: (value) {
        callback(value);
      },
      initialValue: initialValue,
    );
  }

  Widget _buildTimePickerText(BuildContext context, Function(String?) callback, String? initialValue) {
    return TextFormField(
      initialValue: (initialValue?.isNotEmpty ?? false) ? initialValue : _time.format(context),
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        showTimePicker(
            context: context,
            initialTime: _time
        ).then((time) => {
          if (time != null) {
            setState(() {
              _time = time;
            })
          }
        });
      },
      onSaved: (value) {
        callback(value);
      },
      enableInteractiveSelection: false,
    );
  }

  Widget _buildDatePickerText(BuildContext context, Function(String?) callback, String? initialValue) {
    return TextFormField(
      initialValue: (initialValue?.isNotEmpty ?? false) ? initialValue : _date.toString().substring(0,10),
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        showDatePicker(
          context: context,
          initialDate: _date,
          firstDate: DateTime(_date.year, _date.month, _date.day, 0, 0, 0),
          lastDate: DateTime(2100),
        ).then((date) => {
          if (date != null) {
            setState(() {
              _date = date;
            })
          }
        });
      },
      onSaved: (value) {
        callback(value);
      },
      enableInteractiveSelection: false,
    );
  }

  Widget _buildDropDown(List<DropDownItem>? items, Function(String?) callback, String? initialValue) {
    return DropdownButtonFormField(
      value: (initialValue?.isNotEmpty ?? false) ? initialValue : items?[0].name,
      icon: const Icon(Icons.arrow_drop_down),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.green),
      onChanged: (String? newValue) {},
      onSaved: (String? value) {
        callback(value);
      },
      items: items?.map<DropdownMenuItem<String>>((DropDownItem value) {
        return DropdownMenuItem<String>(
          value: value.name,
          child: Text(value.name ?? ""),
        );
      }).toList(),
    );
  }

  _validateAndSubmit() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    _formKey.currentState?.save();
    bool result = await showDialog(
      context: context,
      builder: (context) =>
          FutureProgressDialog(futureBoolean(
              viewModel.addEventAndImage(_event, _imagePath?.path, _isUpdate)
          ), message: Text(Strings.uploadingEvent)),
      barrierDismissible: false,
    );
    if (result) {
      Navigator.pop(context, _event);
    } else {
      scaffoldMessengerKey.currentState?.showSnackBar(
          snackBar(context, Strings.unknownError, true));
    }
  }

}