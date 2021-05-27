import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meetup/constant.dart';
import 'package:flutter_meetup/model/entities/category.dart';
import 'package:flutter_meetup/model/entities/event.dart';
import 'package:flutter_meetup/model/entities/location.dart';
import 'package:flutter_meetup/extension.dart';
import 'package:flutter_meetup/view/customwidgets/checkbox_form_field.dart';
import 'package:flutter_meetup/view/customwidgets/drop_down_item.dart';
import 'package:flutter_meetup/viewmodel/add_event_viewmodel.dart';
import 'package:flutter_meetup/viewmodel/utils/Response.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class AddEventPage extends StatelessWidget {
  static final title = "Add Event";
  static const routeName = '/addEvent';
  final _formKey = GlobalKey<FormState>();
  final Event _event = Event();
  final AddEventViewModel viewModel = AddEventViewModel();

  AddEventPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    viewModel.fetchData();
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
            switch (viewModel.dataResponse.state) {
              case ResponseState.COMPLETE : {
                return Form(
                  key: _formKey,
                  child: ListView (
                    children: [
                      _buildInputText('Title', 'Title is required', (value) => {_event.title = value}),
                      _buildInputText('Description', 'Description is required', (value) => {_event.description = value}),
                      _buildInputText('Date', 'Date is required', (value) => {_event.date = value}),
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
          Text(response.exception ?? Constant.UNKNOWN_ERROR),
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
        showSnackBar(context, response.exception ?? Constant.UNKNOWN_ERROR);
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