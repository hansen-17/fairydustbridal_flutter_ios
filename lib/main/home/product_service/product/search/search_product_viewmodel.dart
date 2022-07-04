import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../models/product.dart';
import '../../../../../utils/api_service.dart';

class SearchProductViewModel extends GetxController {
  TextEditingController productNameText = TextEditingController(text: "");
  Timer? debounce;

  List<Product> _products = [];
  List<Product> get products => _products;

  int _currentProductPage = 1;
  int _totalProductPage = 1;

  bool _loadingProducts = false;
  bool get isLoadingProducts => _loadingProducts;
  void triggerLoadingProducts() {
    _loadingProducts = !_loadingProducts;
    update();
  }

  Future<void> getProducts({int page = 1}) async {
    if (page == 1) _products.clear();

    Map<String, dynamic> query = {
      "limit": "10",
      "page": "$page",
      "code": productNameText.text,
    };

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
}
