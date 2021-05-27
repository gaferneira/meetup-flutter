import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meetup/constants/strings.dart';
import 'package:flutter_meetup/models/category.dart';
import 'package:flutter_meetup/models/event.dart';
import 'package:flutter_meetup/models/location.dart';
import 'package:flutter_meetup/utils/extension.dart';
import 'package:flutter_meetup/widgets/checkbox_form_field.dart';
import 'package:flutter_meetup/models/drop_down_item.dart';
import 'package:flutter_meetup/viewmodels/add_event_viewmodel.dart';
import 'package:flutter_meetup/viewmodels/utils/Response.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class AddEventPage extends StatefulWidget {
  static const routeName = '/addEvent';
  AddEventPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  static final title = "Add Event";
  final _formKey = GlobalKey<FormState>();
  final Event _event = Event();
  final AddEventViewModel viewModel = AddEventViewModel();
  DateTime? _date = DateTime.now();
  TimeOfDay? _time = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    viewModel.fetchData();
    return ChangeNotifierProvider<AddEventViewModel>.value(
    value: viewModel,
    child: Scaffold(
        key: widget.key,
        appBar: AppBar (
          title: Text(title),
        ),
        body: Container(
          margin: EdgeInsets.all(24),
          child: Consumer(
          builder: (context, AddEventViewModel viewModel, _) {
            switch (viewModel.dataResponse.state) {
              case ResponseState.COMPLETE : {
                return Form(
                  key: _formKey,
                  child: ListView (
                    children: [
                      _buildInputText('Title', 'Title is required', (value) => {_event.title = value}),
                      _buildInputText('Description', 'Description is required', (value) => {_event.description = value}),
                      _buildDatePickerText(context),
                      _buildTimePickerText(context),
                      _buildCheckbox('IsOnLine', (value) => {_event.isOnline = value}),
                      _buildInputText('Link', 'Link is required', (value) => {_event.link = value}),
                      _buildDropDown(viewModel.dataResponse.data?[0] as List<Location>, (value) => {_event.location = value}),
                      _buildDropDown(viewModel.dataResponse.data?[1] as List<Category>, (value) => {_event.category = value}),
                      _buildImageWidget(context, viewModel.imageResponse),
                      _buildEventAddedWidget(context, viewModel.addEventResponse),
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
              default :
                return showRetry(viewModel.dataResponse.exception, (){
                  viewModel.fetchData();
                });
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

  Widget _buildTimePickerText(BuildContext context) {
    return TextFormField(
      initialValue: _time!.format(context),
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        showTimePicker(
            context: context,
            initialTime: _time!
        ).then((time) => {
          if (time != null) {
            setState(() {
              _time = time;
            })
          }
        });
      },
    );
  }

  Widget _buildDatePickerText(BuildContext context) {
    final dateNow = DateTime.now();
    return TextFormField(
      initialValue: _date.toString().substring(0,10),
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        showDatePicker(
          context: context,
          initialDate: _date ?? dateNow,
          firstDate: DateTime(dateNow.year, dateNow.month, dateNow.day, 0, 0, 0),
          lastDate: DateTime(2100),
        ).then((date) => {
          if (date != null) {
            setState(() {
              _date = date;
            })
          }
        });
      },
    );
  }

  Widget _buildCheckbox(String text, Function(bool?) callback) {
    return CheckboxFormField(
      title: Text(text),
      onSaved: callback,
    );
  }

  Widget _buildDropDown(List<DropDownItem>? items, Function(String?) callback) {
    return DropdownButtonFormField(
      value: items?[0].name ?? "",
      icon: const Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.blue),
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

  Widget _buildImageWidget(BuildContext context, Response<String> response) {
    switch (response.state) {
      case ResponseState.COMPLETE : return _showImage(response.data);
      case ResponseState.LOADING : {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
      case ResponseState.ERROR : return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _showUploadButton(context),
          Text(response.exception ?? Strings.UNKNOWN_ERROR),
        ]
      );
      case ResponseState.NONE : return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [_showUploadButton(context)],
      );
    }
  }

  Widget _showImage(String? imageUrl) {
    _event.image = imageUrl;
    return FadeInImage.assetNetwork(
      placeholder: "assets/globant_placeholder.png",
      image: imageUrl ?? "",
      fit: BoxFit.fill,
      placeholderCacheHeight: 90,
      placeholderCacheWidth: 120,
      height: 120,
      width: 150,
    );
  }

  Widget _showUploadButton(BuildContext context) {
    return ElevatedButton(onPressed: () {
      uploadImage();
    }, child: Text("Upload image"));
  }

  Widget _buildEventAddedWidget(BuildContext context, Response response) {
    switch (response.state) {
      case ResponseState.COMPLETE : {
        pop(context);
        break;
      }
      case ResponseState.ERROR : {
        showSnackBar(context, response.exception ?? Strings.UNKNOWN_ERROR);
        break;
      }
      default : {}
    }
    return SizedBox();
  }

  uploadImage() async {
    final _picker = ImagePicker();
    PickedFile? image;
    // Check permissions
    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;
    if (permissionStatus.isGranted) {
      image = await _picker.getImage(source: ImageSource.gallery);
      if (image != null) {
        var file = File(image.path);
        viewModel.uploadImage(file);
      } else {
        // TODO handle null image
      }
    } else {
      // TODO show message: grant permissions and try again
    }
  }

}