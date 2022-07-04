import 'dart:async';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../../models/product.dart';
import '../../../../models/transaction.dart';
import '../../../../utils/api_service.dart';

class TransactionProductViewModel extends GetxController {
  DetailTransactionProduct? detailTransactionProduct;

  CarouselController carouselController = CarouselController();

  TextEditingController productNameText = TextEditingController(text: "");
  Timer? debounce;

  List<Product> _products = [];
  List<Product> get products => _products;

  Product? _selectedProduct;
  Product? get selectedProduct => _selectedProduct;
  void setSelectedProduct(Product product) {
    _selectedProduct = product;
    dateRangePickerController.selectedRange = null;
    loadProductInfo();
    update();
  }

  int _currentProductPage = 1;
  int _totalProductPage = 1;

  bool _loadingProducts = false;
  bool get isLoadingProducts => _loadingProducts;
  void triggerLoadingProducts() {
    _loadingProducts = !_loadingProducts;
    update();
  }

  bool _loadingInfo = false;
  bool get isLoadingInfo => _loadingInfo;
  void triggerLoadingInfo() {
    _loadingInfo = !_loadingInfo;
    update();
  }

  DateRangePickerController dateRangePickerController = DateRangePickerController();
  DateTime get beginDate => dateRangePickerController.selectedRange!.startDate!;
  DateTime get endDate => dateRangePickerController.selectedRange!.endDate ?? dateRangePickerController.selectedRange!.startDate!;

  List<DateTime> _blackOutDates = [];
  List<DateTime> get blackOutDates => _blackOutDates;

  @override
  void onInit() async {
    super.onInit();
  }

  Future<void> getProducts({int page = 1}) async {
    if (page == 1) _products.clear();

    Map<String, dynamic> query = {
      "limit": "10",
      "page": "$page",
      "code": productNameText.text,
    };

    if (detailTransactionProduct != null) {
      query["product_type_id"] = detailTransactionProduct!.product.type.id;
      query["product_category_id"] = detailTransactionProduct!.product.category.id;
    }

    if (page == 1) triggerLoadingProducts();
    if (page != 1) insertLoadingCard();

    dynamic result = (await ApiService.me.get("master/product", query: query)).body;

    if (page == 1) triggerLoadingProducts();
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

  Future<void> loadMoreProducts() async {
    if (_currentProductPage == _totalProductPage) return;
    _currentProductPage += 1;
    await getProducts(page: _currentProductPage);
  }

  void insertLoadingCard() {
    _products.add(Product(id: "", code: "", type: ProductType(id: "", name: ""), category: ProductCategory(id: "", name: "")));
    update();
  }

  void removeLoadingCard() {
    _products.removeWhere((Product product) => product.id == "");
    update();
  }

  Future<void> loadProductInfo() async {
    triggerLoadingInfo();
    dynamic result = (await ApiService.me.get("master/product/${_selectedProduct!.id}")).body;
    triggerLoadingInfo();

    if (result != null) {
      dynamic data = result["data"]["transaction"];
      data.forEach((datum) {
        DateTime rentDate = DateTime.parse(datum["rent_date"]);
        DateTime returnDate = DateTime.parse(datum["return_date"]);

        for (int i = 0; i <= returnDate.difference(rentDate).inDays; i++) {
          _blackOutDates.add(rentDate.add(Duration(days: i)));
          print(_blackOutDates);
        }
      });
    }

    update();
  }
}
