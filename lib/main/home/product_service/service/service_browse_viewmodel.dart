import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../models/service.dart';
import '../../../../utils/app_color.dart';
import '../../../../utils/custom_dropdown.dart';
import '../../../../utils/api_service.dart';
import '../../../../utils/size_util.dart';

class ServiceBrowseViewModel extends GetxController {
  late Offset tapPosition;

  bool _loading = false;
  bool get isLoading => _loading;
  void triggerLoading() {
    _loading = !_loading;
    update();
  }

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

  final ServiceType allType = ServiceType(id: "", name: "ALL TYPES");
  late ServiceType _selectedType;
  ServiceType get selectedType => _selectedType;
  void setServiceType(String id) {
    if (id == "") _selectedType = _serviceTypes[0];
    _selectedType = _serviceTypes.firstWhere((ServiceType type) => type.id == id);
    _currentServicePage = 1;
    getServices();
  }

  List<Service> _services = [];
  List<Service> get services => _services;
  int _currentServicePage = 1;
  int _totalServicePage = 1;

  @override
  void onInit() async {
    super.onInit();
    _selectedType = allType;

    getServiceTypes();
    getServices();
  }

  Future<void> getServiceTypes() async {
    _serviceTypes.clear();
    _serviceTypes.add(ServiceType(id: "", name: "ALL TYPES"));
    dynamic result = (await ApiService.me.get("master/service-type")).body;

    if (result != null) {
      dynamic data = result["data"]["data"];
      data.forEach((datum) {
        _serviceTypes.add(ServiceType.fromJson(datum));
      });
    }

    if (_serviceTypes.isNotEmpty) _selectedType = _serviceTypes[0];
    update();
  }

  Future<void> getServices({int page = 1}) async {
    if (page == 1) _services.clear();
    Map<String, dynamic> query = {
      "limit": "10",
      "page": "$page",
    };
    if (_selectedType.id != "") query["service_type_id"] = _selectedType.id;

    if (page == 1) triggerLoading();
    if (page != 1) insertLoadingCard();

    dynamic result = (await ApiService.me.get("master/service", query: query)).body;

    if (page == 1) triggerLoading();
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

  Future<void> loadMoreService() async {
    if (_currentServicePage == _totalServicePage) return;

    _currentServicePage += 1;
    await getServices(page: _currentServicePage);
  }

  void insertLoadingCard() {
    _services.add(Service(id: "", description: "", type: allType, price: 0));
    update();
  }

  void removeLoadingCard() {
    _services.removeWhere((Service service) => service.id == "");
    update();
  }

  Future<void> deleteService(Service service) async {
    dynamic result = (await ApiService.me.delete("master/service/${service.id}")).body;
    if (result != null) {
      _services.remove(service);
      update();
    }
  }
}
