import 'dart:io';

import '../inspiration_browse_viewmodel.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../../utils/api_service.dart';
import '../../../../models/photo.dart';

class AddInspirationViewModel extends GetxController {
  TextEditingController folderNameText = TextEditingController(text: "");

  bool isEdit = false;
  Group? group;

  @override
  void onInit() async {
    super.onInit();
    group = Get.arguments;
    if (group != null) {
      isEdit = true;
      folderNameText.text = group!.name;
      loadPhoto();
    }
  }

  void loadPhoto() {
    _imageFileList = [];
    group!.photos.forEach((Photo photo) async {
      print(photo.photoUrl);
      dio.Response response = await dio.Dio().get(photo.photoUrl, options: dio.Options(responseType: dio.ResponseType.bytes));
      Directory documentDirectory = await getApplicationDocumentsDirectory();
      File file = File(join(documentDirectory.path, "${photo.photoUrl.split("/").last}"));
      file.writeAsBytesSync(response.data);
      _imageFileList.add(XFile(file.path));
      update();
    });
  }

  Future<void> saveInspiration() async {
    FormData form = FormData({
      "name": folderNameText.text,
    });

    int index = 0;
    _imageFileList.forEach((XFile xFile) {
      form.files.add(
        MapEntry<String, MultipartFile>(
          "photo[${index.toString()}]",
          MultipartFile(File(xFile.path), filename: xFile.path),
        ),
      );
      index++;
    });

    dynamic result;
    if (isEdit) {
      result = (await ApiService.me.put("master/gallery/${group!.id}", form)).body;
    } else {
      result = (await ApiService.me.post("master/gallery", form)).body;
    }

    if (result != null) Get.back();
    Get.find<InspirationBrowseViewModel>().getPhotos();
  }

  final ImagePicker _imagePicker = ImagePicker();
  List<XFile> _imageFileList = [];
  List<XFile> get imageFileList => _imageFileList;
  void removeImageFile(int index) {
    _imageFileList.removeAt(index);
    update();
  }

  Future<void> pickMultiImage() async {
    try {
      List<XFile>? pickedFileList = await _imagePicker.pickMultiImage(imageQuality: 25);
      if (pickedFileList != null) _imageFileList.addAll(pickedFileList);
      update();
    } catch (e) {
      update();
    }
  }
}
