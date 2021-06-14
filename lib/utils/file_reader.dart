import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class FileReader {
  
  final _picker = ImagePicker();

  pickImage(Function(ImagePath) onSuccess, Function onError, Function onPermissionNotGranted) async {
    PickedFile? image;
    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;
    if (permissionStatus.isGranted) {
      image = await _picker.getImage(source: ImageSource.gallery);
      if (image != null) {
        onSuccess(ImagePath(true, image.path));
      } else {
        onError();
      }
    } else {
      onPermissionNotGranted();
    }
  }
  
}

class ImagePath {
  bool? fromDevice;
  String? path;
  
  ImagePath(
    this.fromDevice,
    this.path,
  ) : super();
}