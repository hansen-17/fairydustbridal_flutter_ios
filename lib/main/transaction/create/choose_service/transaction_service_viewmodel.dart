import 'dart:async';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../../models/service.dart';
import '../../../../models/transaction.dart';
import '../../../../utils/api_service.dart';

class TransactionServiceViewModel extends GetxController {
  DetailTransactionService? detailTransactionService;

  CarouselController carouselController = CarouselController();

  TextEditingController serviceNameText = TextEditingController(text: "");
  Timer? debounce;

  List<Service> _services = [];
  List<Service> get services => _services;

  Service? _selectedService;
  Service? get selectedService => _selectedService;
  void setSelectedService(Service service) {
    _selectedService = service;
    dateRangePickerController.selectedRange = null;
    update();
  }

  int _currentServicePage = 1;
  int _totalServicePage = 1;

  bool _loadingServices = false;
  bool get isLoadingServices => _loadingServices;
  void triggerLoadingServices() {
    _loadingServices = !_loadingServices;
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

  @override
  void onInit() async {
    super.onInit();
  }

  Future<void> getServices({int page = 1}) async {
    if (page == 1) _services.clear();

    Map<String, dynamic> query = {
      "limit": "10",
      "page": "$page",
      "name": serviceNameText.text,
    };

    if (detailTransactionService != null) {
      query["service_type_id"] = detailTransactionService!.service.type!.id;
    }

    if (page == 1) triggerLoadingServices();
    if (page != 1) insertLoadingCard();

    dynamic result = (await ApiService.me.get("master/service", query: query)).body;

    if (page == 1) triggerLoadingServices();
    if (page != 1) removeLoadingCard();

    if (result != null) {
      dynamic data = result["data"]["data"];
      data.forEach((datum) {
        _services.add(Service.fromJson(datum));
      });
      _currentServicePage = result["data"]["current_page"];
      _totalServicePage = result["data"]["last_page"];
    }

    update();
  }

  Future<void> loadMoreServices() async {
    if (_currentServicePage == _totalServicePage) return;
    _currentServicePage += 1;
    await getServices(page: _currentServicePage);
  }

  void insertLoadingCard() {
    _services.add(Service(id: "", description: "", price: 0));
    update();
  }

  void removeLoadingCard() {
    _services.removeWhere((Service service) => service.id == "");
    update();
  }
}
