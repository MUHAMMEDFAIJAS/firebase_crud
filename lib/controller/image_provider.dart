import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project/services/project_service.dart';

class ImageProviderr extends ChangeNotifier {
  ProjectService service = ProjectService();
  File? pickedImage;
  File? editpickedImage;
  ImagePicker image = ImagePicker();

  Future<void> pickImg() async {
    var img = await image.pickImage(source: ImageSource.gallery);
    pickedImage = File(img!.path);
    notifyListeners();
  }

  Future<void> editpickimg() async {
    var img = await image.pickImage(source: ImageSource.gallery);
    pickedImage = File(img!.path);
    notifyListeners();
  }

  void clearpickedimage() {
    pickedImage = null;
    notifyListeners();
  }

  void cleareditimage() {
    editpickedImage = null;
    notifyListeners();
  }
}
