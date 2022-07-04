import 'dart:io';

import '../package_browse_viewmodel.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../../utils/api_service.dart';
import '../../../../../utils/size_util.dart';
import '../../../../models/package.dart';
import '../../../../models/product.dart';
import '../../../../models/service.dart';
import '../../../../utils/app_color.dart';
import '../../../../utils/custom_dropdown.dart';

class AddPackageViewModel extends GetxController {
  TextEditingController packageNameText = TextEditingController(text: "");
  TextEditingController priceText = TextEditingController(text: "");
  TextEditingController serviceNameText = TextEditingController(text: "");

  List<PackageDetailProduct> packageDetailProducts = [];
  void addNewPackageDetailProducts() {
    packageDetailProducts.add(
      PackageDetailProduct(type: _productTypes[0], category: _productCategories[0], price: 0),
    );
    update();
  }

  void removePackageDetailProducts(int index) {
    packageDetailProducts.removeAt(index);
    update();
  }

  List<PackageDetailService> packageDetailServices = [];
  void addNewPackageDetailServices() {
    packageDetailServices.add(
      PackageDetailService(service: _services[0], price: 0),
    );
    update();
  }

  void removePackageDetailServices(int index) {
    packageDetailServices.removeAt(index);
    update();
  }

  List<ProductType> _productTypes = [];
  List<ProductType> get productTypes => _productTypes;
  List<DropdownItem> get productTypeItems {
    return _productTypes
        .map((ProductType type) => DropdownItem(
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

  List<ProductCategory> _productCategories = [];
  List<ProductCategory> get productCategories => _productCategories;
  List<DropdownItem> get productCategoryItems {
    return _productCategories
        .map((ProductCategory category) => DropdownItem(
            value: category.id,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.h),
              child: Text(category.name, style: selectButtonTextStyle, maxLines: 1, overflow: TextOverflow.fade, softWrap: false),
            )))
        .toList();
  }

  List<Service> _services = [];
  List<Service> get services => _services;
  List<DropdownItem> get serviceItems {
    return _services
        .map((Service service) => DropdownItem(
            value: service.id,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.h),
              child: Text(
                service.description,
                style: selectButtonTextStyle,
                maxLines: 1,
                overflow: TextOverflow.fade,
                softWrap: false,
              ),
            )))
        .toList();
  }

  final TextStyle selectButtonTextStyle = TextStyle(color: AppColor.primary, fontSize: 12.sp, fontWeight: FontWeight.bold);

  void setProductType(String id, int index) {
    packageDetailProducts[index].type = _productTypes.firstWhere((ProductType type) => type.id == id);
    update();
  }

  void setProductCategory(String id, int index) {
    packageDetailProducts[index].category = _productCategories.firstWhere((ProductCategory category) => category.id == id);
    update();
  }

  void setService(String id, int index) {
    packageDetailServices[index].service = _services.firstWhere((Service service) => service.id == id);
    update();
  }

  bool isEdit = false;
  Package? package;

  @override
  void onInit() async {
    super.onInit();
    package = Get.arguments;
    if (package != null) {
      isEdit = true;
      packageNameText.text = package!.name;
      priceText.text = NumberFormat("#,###").format(package!.price).replaceAll(",", ".");
      packageDetailProducts.addAll(package!.products!);
      packageDetailServices.addAll(package!.services!);
      loadPhoto();
    }

    getProductTypes();
    getProductCategories();
    getServices();
  }

  Future<void> loadPhoto() async {
    print(package!.photo!.photoUrl);
    dio.Response response = await dio.Dio().get(package!.photo!.photoUrl, options: dio.Options(responseType: dio.ResponseType.bytes));
    final documentDirectory = await getApplicationDocumentsDirectory();
    final file = File(join(documentDirectory.path, "${package!.photo!.photoUrl.split("/").last}"));
    file.writeAsBytesSync(response.data);
    _imageFile = XFile(file.path);
    update();
  }

  Future<void> getProductTypes() async {
    _productTypes.clear();
    dynamic result = (await ApiService.me.get("master/product-type")).body;

    if (result != null) {
      dynamic data = result["data"]["data"];
      data.forEach((datum) {
        _productTypes.add(ProductType.fromJson(datum));
      });
    }

    update();
  }

  Future<void> getProductCategories() async {
    _productCategories.clear();
    dynamic result = (await ApiService.me.get("master/product-category")).body;

    if (result != null) {
      dynamic data = result["data"]["data"];
      data.forEach((datum) {
        _productCategories.add(ProductCategory.fromJson(datum));
      });
    }

    update();
  }

  Future<void> getServices() async {
    _services.clear();
    Map<String, dynamic> query = {"limit": "1000", "page": "1"};
    dynamic result = (await ApiService.me.get("master/service", query: query)).body;

    if (result != null) {
      dynamic data = result["data"]["data"];
      data.forEach((datum) {
        _services.add(Service.fromJson(datum));
      });
    }

    update();
  }

  Future<void> savePackage() async {
    FormData form = FormData({
      "name": packageNameText.text,
      "price": int.tryParse(priceText.text.replaceAll(".", "")) ?? 0,
    });

    if (_imageFile != null) {
      File file = File(_imageFile!.path);
      form.files.add(
        MapEntry<String, MultipartFile>(
          "image",
          MultipartFile(File(file.path), filename: file.path),
        ),
      );
    }

    int index = 0;
    packageDetailProducts.forEach((PackageDetailProduct packageDetailProduct) {
      form.fields.addAll(
        [
          MapEntry<String, String>(
            "packageProducts[$index][product_type_id]",
            packageDetailProduct.type.id,
          ),
          MapEntry<String, String>(
            "packageProducts[$index][product_category_id]",
            packageDetailProduct.category.id,
          ),
          MapEntry<String, String>(
            "packageProducts[$index][price]",
            "0",
          ),
        ],
      );
      index += 1;
    });

    index = 0;
    packageDetailServices.forEach((PackageDetailService packageDetailService) {
      form.fields.addAll(
        [
          MapEntry<String, String>(
            "packageServices[$index][service_id]",
            packageDetailService.service.id,
          ),
          MapEntry<String, String>(
            "packageServices[$index][price]",
            "0",
          ),
        ],
      );
      index += 1;
    });

    dynamic result;
    if (isEdit) {
      result = (await ApiService.me.put("master/package/${package!.id}", form)).body;
    } else {
      result = (await ApiService.me.post("master/package", form)).body;
    }

    if (result != null) Get.back();
    Get.find<PackageBrowseViewModel>().getPackages();
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
