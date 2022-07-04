import 'dart:io';

import '../product_browse_viewmodel.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../../models/photo.dart';
import '../../../../../models/product.dart';
import '../../../../../utils/api_service.dart';
import '../../../../../utils/app_color.dart';
import '../../../../../utils/custom_dropdown.dart';
import '../../../../../utils/size_util.dart';

class AddProductViewModel extends GetxController {
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

  final TextStyle selectButtonTextStyle = TextStyle(color: AppColor.primary, fontSize: 12.sp, fontWeight: FontWeight.bold);

  ProductType? _selectedType;
  ProductType? get selectedType => _selectedType;
  void setProductType(String id) {
    if (id == "") _selectedType = _productTypes[0];
    _selectedType = _productTypes.firstWhere((ProductType type) => type.id == id);
    update();
  }

  ProductCategory? _selectedCategory;
  ProductCategory? get selectedCategory => _selectedCategory;
  void setProductCategory(String id) {
    if (id == "") _selectedCategory = _productCategories[0];
    _selectedCategory = _productCategories.firstWhere((ProductCategory category) => category.id == id);
    update();
  }

  bool isEdit = false;
  Product? product;

  @override
  void onInit() async {
    super.onInit();
    product = Get.arguments;
    if (product != null) {
      isEdit = true;
      _selectedType = product!.type;
      _selectedCategory = product!.category;
      _imageFileList = [];
      product!.photos.forEach((Photo photo) async {
        print(photo.photoUrl);
        dio.Response response = await dio.Dio().get(photo.photoUrl, options: dio.Options(responseType: dio.ResponseType.bytes));
        final documentDirectory = await getApplicationDocumentsDirectory();
        final file = File(join(documentDirectory.path, "${photo.photoUrl.split("/").last}"));
        file.writeAsBytesSync(response.data);
        _imageFileList.add(XFile(file.path));
        update();
      });
    }

    getProductTypes();
    getProductCategories();
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

    if (_productTypes.isNotEmpty && !isEdit) _selectedType = _productTypes[0];
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

    if (_productCategories.isNotEmpty && !isEdit) _selectedCategory = _productCategories[0];
    update();
  }

  Future<void> saveProduct() async {
    FormData form = FormData({
      "product_category_id": _selectedCategory?.id,
      "product_type_id": _selectedType?.id,
      "price": 0,
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
      result = (await ApiService.me.put("master/product/${product!.id}", form)).body;
    } else {
      result = (await ApiService.me.post("master/product", form)).body;
    }

    if (result != null) Get.back();
    Get.find<ProductBrowseViewModel>().getProducts();
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
      // _imagePicker.update();
    } catch (e) {
      update();
    }
  }
}
