import 'dart:async';

import '../create_transaction_viewmodel.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../models/customer.dart';
import '../../../../utils/api_service.dart';

class TransactionCustomerViewModel extends GetxController {
  TextEditingController customerNameText = TextEditingController(text: "");

  CarouselController carouselController = CarouselController();

  Timer? debounce;

  List<Customer> _customers = [];
  List<Customer> get customers => _customers;

  int _currentCustomerPage = 1;
  int _totalCustomerPage = 1;

  bool _loadingCustomers = false;
  bool get isLoadingCustomers => _loadingCustomers;
  void triggerLoadingCustomers() {
    _loadingCustomers = !_loadingCustomers;
    update();
  }

  TextEditingController newCustomerNameText = TextEditingController(text: "");
  String? validateName() {
    if (!_validate) return null;
    if (newCustomerNameText.text.isEmpty) return "Customer Name cannot be empty!";
    return null;
  }

  TextEditingController newCustomerInstagramText = TextEditingController(text: "");

  TextEditingController newCustomerEmailText = TextEditingController(text: "");
  String? validateEmail() {
    if (!_validate) return null;
    if (!(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(newCustomerEmailText.text))) return "Please enter a valid email!";
    return null;
  }

  TextEditingController newCustomerPhoneText = TextEditingController(text: "");
  String? validatePhone() {
    if (!_validate) return null;
    if (newCustomerPhoneText.text.isEmpty) return "Customer Phone cannot be empty!";
    if (newCustomerPhoneText.text.length < 8) return "Customer Phone has to be at least 8 digits!";
    return null;
  }

  bool _validate = false;
  bool get isStartValidating => _validate;
  void startValidation() {
    if (!_validate) _validate = true;
  }

  bool _loadingAddCustomer = false;
  bool get isLoadingAddCustomer => _loadingAddCustomer;
  void triggerLoadingAddCustomer() {
    _loadingAddCustomer = !_loadingAddCustomer;
    update();
  }

  @override
  void onInit() async {
    super.onInit();
    getCustomers();
  }

  Future<void> getCustomers({int page = 1}) async {
    if (page == 1) _customers.clear();

    Map<String, dynamic> query = {
      "limit": "10",
      "page": "$page",
      "name": customerNameText.text,
    };

    if (page == 1) triggerLoadingCustomers();
    if (page != 1) insertLoadingCard();

    dynamic result = (await ApiService.me.get("master/customer", query: query)).body;

    if (page == 1) triggerLoadingCustomers();
    if (page != 1) removeLoadingCard();

    if (result != null) {
      dynamic data = result["data"]["data"];
      data.forEach((datum) {
        _customers.add(Customer.fromJson(datum));
      });
      _currentCustomerPage = result["data"]["current_page"];
      _totalCustomerPage = result["data"]["last_page"];
    }

    update();
  }

  Future<void> loadMoreCustomers() async {
    if (_currentCustomerPage == _totalCustomerPage) return;
    _currentCustomerPage += 1;
    await getCustomers(page: _currentCustomerPage);
  }

  void insertLoadingCard() {
    _customers.add(Customer(id: "", name: "", phoneNumber: ""));
    update();
  }

  void removeLoadingCard() {
    _customers.removeWhere((Customer customer) => customer.id == "");
    update();
  }

  void _clearText() {
    newCustomerNameText.text = "";
    newCustomerPhoneText.text = "";
    newCustomerEmailText.text = "";
    newCustomerInstagramText.text = "";
    _validate = false;
  }

  Future<void> addCustomer() async {
    triggerLoadingAddCustomer();
    Map<String, dynamic> body = {
      "name": newCustomerNameText.text,
      "email": newCustomerEmailText.text,
      "instagram": newCustomerInstagramText.text,
      "phone_number": newCustomerPhoneText.text,
    };

    dynamic result = (await ApiService.me.post("master/customer", body)).body;
    triggerLoadingAddCustomer();

    if (result != null) {
      Customer customer = Customer.fromJson(result["data"]);
      Get.find<CreateTransactionViewModel>().setCustomer(customer);
      customerNameText.text = customer.name;
      _customers.clear();
      _customers.add(customer);
      _clearText();
      Get.back();
    }
  }
}
