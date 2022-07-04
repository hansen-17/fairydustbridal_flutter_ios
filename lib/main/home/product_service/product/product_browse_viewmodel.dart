import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../models/product.dart';
import '../../../../utils/api_service.dart';
import '../../../../utils/app_color.dart';
import '../../../../utils/custom_dropdown.dart';
import '../../../../utils/size_util.dart';

class ProductBrowseViewModel extends GetxController {
  late Offset tapPosition;

  bool _loading = false;
  bool get isLoading => _loading;
  void triggerLoading() {
    _loading = !_loading;
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

  final TextStyle selectButtonTextStyle = TextStyle(color: AppColor.primary, fontSize: 12.sp, fontWeight: FontWeight.bold);

  final ProductType allType = ProductType(id: "", name: "ALL TYPES");
  late ProductType _selectedType;
  ProductType get selectedType => _selectedType;
  void setProductType(String id) {
    if (id == "") _selectedType = _productTypes[0];
    _selectedType = _productTypes.firstWhere((ProductType type) => type.id == id);
    _currentProductPage = 1;
    getProducts();
  }

  final ProductCategory allCategory = ProductCategory(id: "", name: "ALL CATEGORIES");
  late ProductCategory _selectedCategory;
  ProductCategory get selectedCategory => _selectedCategory;
  void setProductCategory(String id) {
    if (id == "") _selectedCategory = _productCategories[0];
    _selectedCategory = _productCategories.firstWhere((ProductCategory category) => category.id == id);
    _currentProductPage = 1;
    getProducts();
  }

  List<Product> _products = [];
  List<Product> get products => _products;
  int _currentProductPage = 1;
  int _totalProductPage = 1;

  @override
  void onInit() async {
    super.onInit();
    _selectedType = allType;
    _selectedCategory = allCategory;

    getProductTypes();
    getProductCategories();
    getProducts();
  }

  Future<void> getProductTypes() async {
    _productTypes.clear();
    _productTypes.add(ProductType(id: "", name: "ALL TYPES"));
    dynamic result = (await ApiService.me.get("master/product-type")).body;

    if (result != null) {
      dynamic data = result["data"]["data"];
      data.forEach((datum) {
        _productTypes.add(ProductType.fromJson(datum));
      });
    }

    if (_productTypes.isNotEmpty) _selectedType = _productTypes[0];
    update();
  }

  Future<void> getProductCategories() async {
    _productCategories.clear();
    _productCategories.add(ProductCategory(id: "", name: "ALL CATEGORIES"));
    dynamic result = (await ApiService.me.get("master/product-category")).body;

    if (result != null) {
      dynamic data = result["data"]["data"];
      data.forEach((datum) {
        _productCategories.add(ProductCategory.fromJson(datum));
      });
    }

    if (_productCategories.isNotEmpty) _selectedCategory = _productCategories[0];
    update();
  }

  Future<void> getProducts({int page = 1}) async {
    if (page == 1) _products.clear();
    Map<String, dynamic> query = {
      "limit": "10",
      "page": "$page",
    };
    if (_selectedCategory.id != "") query["product_category_id"] = _selectedCategory.id;
    if (_selectedType.id != "") query["product_type_id"] = _selectedType.id;

    if (page == 1) triggerLoading();
    if (page != 1) insertLoadingCard();

    dynamic result = (await ApiService.me.get("master/product", query: query)).body;

    if (page == 1) triggerLoading();
    if (page != 1) removeLoadingCard();

    if (result != null) {
      dynamic data = result["data"]["data"];
      data.forEach((datum) {
        _products.add(Product.fromJson(datum));
      });
      _currentProductPage = result["data"]["current_page"];
      _totalProductPage = result["data"]["last_page"];
    }

    update();
  }

  Future<void> loadMoreProduct() async {
    if (_currentProductPage == _totalProductPage) return;

    _currentProductPage += 1;
    await getProducts(page: _currentProductPage);
  }

  void insertLoadingCard() {
    _products.add(Product(id: "", code: "", category: allCategory, type: allType));
    update();
  }

  void removeLoadingCard() {
    _products.removeWhere((Product product) => product.id == "");
    update();
  }

  Future<void> deleteProduct(Product product) async {
    dynamic result = (await ApiService.me.delete("master/product/${product.id}")).body;
    if (result != null) {
      _products.remove(product);
      update();
    }
  }
}
