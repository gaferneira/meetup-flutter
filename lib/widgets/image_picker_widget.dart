import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meetup/constants/assets.dart';
import 'package:flutter_meetup/constants/strings.dart';
import 'package:flutter_meetup/utils/file_reader.dart';

class ImagePickerWidget {

  FileReader fileReader = FileReader();
  Function(ImagePath) onPickerSuccess;
  Function onPickerError;
  Function onPermissionNotGranted;
  
  ImagePickerWidget(
    this.onPickerSuccess,
    this.onPickerError,
    this.onPermissionNotGranted,
  ) : super();

  Widget buildImagePickerWidget(BuildContext context, ImagePath? imagePath) {
    if (imagePath?.path?.isEmpty ?? true) {
      return _showUploadButton(context);
    } else {
      return _showImage(imagePath);
    }
  }

  Widget _showImage(ImagePath? imagePath) {
    return Padding(
        padding: EdgeInsets.fromLTRB(0, 24, 0, 24),
        child: GestureDetector(
          child: AspectRatio(
              aspectRatio: 16/9,
              child: _showImageWidget(imagePath)
          ),
          onTap: () {
            _pickImage();
          },
        )
    );
  }

  Widget _showImageWidget(ImagePath? imagePath) {
    if (imagePath?.fromDevice ?? false) {
      return Image.file(
        File(imagePath?.path ?? ""),
        fit: BoxFit.fitHeight,
      );
    } else {
      return FadeInImage.assetNetwork(
        placeholder: Assets.placeHolder,
        image: imagePath?.path ?? "",
        fit: BoxFit.fitHeight,
      );
    }
  }

  Widget _showUploadButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(24),
      child: ElevatedButton(
        onPressed: () {
          _pickImage();
          }, child: Text(Strings.uploadImage),
      ),
    );
  }

  _pickImage() {
    fileReader.pickImage((image) {
      onPickerSuccess(image);
    }, (){
      onPickerError();
    }, (){
      onPermissionNotGranted();
    });
  }
  
}