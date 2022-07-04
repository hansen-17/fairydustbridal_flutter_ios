import 'dart:io';

import '../service_browse_viewmodel.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../../models/service.dart';
import '../../../../../utils/api_service.dart';
import '../../../../../utils/app_color.dart';
import '../../../../../utils/custom_dropdown.dart';
import '../../../../../utils/size_util.dart';

class AddServiceViewModel extends GetxController {
  TextEditingController serviceNameText = TextEditingController(text: "");

  List<ServiceType> _serviceTypes = [];
  List<ServiceType> get serviceTypes => _serviceTypes;
  List<DropdownItem> get serviceTypeItems {
    return _serviceTypes
        .map((ServiceType type) => DropdownItem(
            value: type.id,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.h),
              child: Text(
                type.name,
                style: selectButtonTextStyle,
                maxLines: 1,
                overflow: TextOverflow.fade,
                softWrap: false,
              ),
            )))
        .toList();
  }

  final TextStyle selectButtonTextStyle = TextStyle(color: AppColor.primary, fontSize: 12.sp, fontWeight: FontWeight.bold);

  ServiceType? _selectedType;
  ServiceType? get selectedType => _selectedType;
  void setServiceType(String id) {
    if (id == "") _selectedType = _serviceTypes[0];
    _selectedType = _serviceTypes.firstWhere((ServiceType type) => type.id == id);
    update();
  }

  bool isEdit = false;
  Service? service;

  @override
  void onInit() async {
    super.onInit();
    service = Get.arguments;
    if (service != null) {
      isEdit = true;
      serviceNameText.text = service!.description;
      _selectedType = service!.type;
      loadPhoto();
    }

    getServiceTypes();
  }

  Future<void> loadPhoto() async {
    dio.Response response = await dio.Dio().get(service!.photo!.photoUrl, options: dio.Options(responseType: dio.ResponseType.bytes));
    final documentDirectory = await getApplicationDocumentsDirectory();
    final file = File(join(documentDirectory.path, "${service!.photo!.photoUrl.split("/").last}"));
    file.writeAsBytesSync(response.data);
    _imageFile = XFile(file.path);
    update();
  }

  Future<void> getServiceTypes() async {
    _serviceTypes.clear();
    dynamic result = (await ApiService.me.get("master/service-type")).body;

    if (result != null) {
      dynamic data = result["data"]["data"];
      data.forEach((datum) {
        _serviceTypes.add(ServiceType.fromJson(datum));
      });
    }

    if (_serviceTypes.isNotEmpty && !isEdit) _selectedType = _serviceTypes[0];
    update();
  }

  Future<void> saveService() async {
    FormData form = FormData({
      "description": serviceNameText.text,
      "service_type_id": _selectedType?.id,
      "price": 0,
    });

    if (_imageFile != null) {
      form.files.add(
        MapEntry<String, MultipartFile>(
          "image",
          MultipartFile(File(_imageFile!.path), filename: _imageFile!.path),
        ),
      );
    }

    dynamic result;
    if (isEdit) {
      result = (await ApiService.me.put("master/service/${service!.id}", form)).body;
    } else {
      result = (await ApiService.me.post("master/service", form)).body;
    }

    if (result != null) Get.back();
    Get.find<ServiceBrowseViewModel>().getServices();
  }

  final ImagePicker _imagePicker = ImagePicker();
  XFile? _imageFile;
  XFile? get imageFile => _imageFile;
  void removeImageFile() {
    _imageFile = null;
    update();
  }

  Future<void> pickMultiImage() async {
    try {
      XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 25,
      );
      if (pickedFile != null) _imageFile = pickedFile;
      update();
    } catch (e) {
      update();
    }
  }
}
