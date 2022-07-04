import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../models/package.dart';
import '../../../../utils/api_service.dart';

class TransactionPackageViewModel extends GetxController {
  TextEditingController packageNameText = TextEditingController(text: "");
  Timer? debounce;

  List<Package> _packages = [];
  List<Package> get packages => _packages;

  int _currentPackagePage = 1;
  int _totalPackagePage = 1;

  bool _loading = false;
  bool get isLoading => _loading;
  void triggerLoading() {
    _loading = !_loading;
    update();
  }

  @override
  void onInit() async {
    super.onInit();
    getPackages();
  }

  Future<void> getPackages({int page = 1}) async {
    if (page == 1) _packages.clear();

    Map<String, dynamic> query = {
      "limit": "10",
      "page": "$page",
      "name": packageNameText.text,
    };

    if (page == 1) triggerLoading();
    if (page != 1) insertLoadingCard();

    dynamic result = (await ApiService.me.get("master/package", query: query)).body;

    if (page == 1) triggerLoading();
    if (page != 1) removeLoadingCard();

    if (result != null) {
      dynamic data = result["data"]["data"];
      data.forEach((datum) {
        _packages.add(Package.fromJson(datum));
      });
      _currentPackagePage = result["data"]["current_page"];
      _totalPackagePage = result["data"]["last_page"];
    }

    update();
  }

  Future<void> loadMorePackages() async {
    if (_currentPackagePage == _totalPackagePage) return;
    _currentPackagePage += 1;
    await getPackages(page: _currentPackagePage);
  }

  void insertLoadingCard() {
    _packages.add(Package(id: "", name: "", price: 0));
    update();
  }

  void removeLoadingCard() {
    _packages.removeWhere((Package package) => package.id == "");
    update();
  }
}
