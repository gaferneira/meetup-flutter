import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meetup/model/entities/Category.dart';
import 'package:flutter_meetup/model/entities/Event.dart';
import 'package:flutter_meetup/model/entities/Location.dart';
import 'package:flutter_meetup/view/customwidgets/CheckboxFormField.dart';
import 'package:flutter_meetup/view/customwidgets/DropDownItem.dart';
import 'package:flutter_meetup/viewmodel/AddEventViewModel.dart';
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
                      _buildInputText('Image Description', 'Image Description is required', (value) => {_event.imageDescription = value}),
                      _buildCheckbox('IsOnLine', (value) => {_event.isOnline = value}),
                      _buildInputText('Link', 'Link is required', (value) => {_event.link = value}),
                      _buildDropDown(viewModel.dataResponse.data?[0] as List<Location>, (value) => {_event.location = value}),
                      _buildDropDown(viewModel.dataResponse.data?[1] as List<Category>, (value) => {_event.category = value}),
                      _buildImageWidget(context, viewModel.imageResponse),
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
                return _message(viewModel.dataResponse.exception ?? "Unknown error");
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
      style: const TextStyle(color: Colors.lightGreen),
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
      case ResponseState.LOADING : return _showUploadButton(context, "Upload image");
      case ResponseState.ERROR : return _showUploadButton(context, response.exception ?? "Unknown error");
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

  Widget _showUploadButton(BuildContext context, String message) {
    return ElevatedButton(onPressed: () {
      uploadImage();
    }, child: Text(message));
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

  void _handleError(String error, BuildContext context) {
    if (error != null) {
      // Can't show the snack bar before the widget is built, so run it in the future.
      Future.delayed(Duration(milliseconds: 200)).then((value) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            duration: Duration(seconds: 4),
            content: Text(
              error,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            backgroundColor: Theme.of(context).colorScheme.background,
          ),
        );
      });
    }
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