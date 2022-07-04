import 'package:drawerbehavior/menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/user.dart';
import '../../utils/global_controller.dart';
import '../../utils/size_util.dart';
import 'inspiration/inspiration_browse_widget.dart';
import 'package/package_browse_widget.dart';
import 'product_service/list_category_widget.dart';
import 'product_service/product/product_browse_widget.dart';
import 'product_service/service/service_browse_viewmodel.dart';
import 'product_service/service/service_browse_widget.dart';

class HomeViewModel extends GetxController {
  //Navigation Drawer
  String _selectedItemId = "1";
  String get selectedItemId => _selectedItemId;
  void setItemId(String id) {
    _selectedItemId = id;
    _selectedWidget = menuItems.firstWhere((menuItem) => menuItem.id == id).data;

    ServiceBrowseViewModel model = Get.find<ServiceBrowseViewModel>();
    switch (id) {
      case "1b":
        model.setServiceType(model.serviceTypes.firstWhere((type) => type.name.toLowerCase() == "make up").id);
        print(model.serviceTypes.firstWhere((type) => type.name.toLowerCase() == "make up").name);
        break;
      case "1c":
        model.setServiceType(model.serviceTypes.firstWhere((type) => type.name.toLowerCase() == "fotografi").id);
        break;
      case "1d":
        model.setServiceType(model.serviceTypes.firstWhere((type) => type.name.toLowerCase() == "lain-lain").id);
        break;
    }
    update();
  }

  Widget _selectedWidget = ListCategoryWidget();
  Widget get selectedWidget => _selectedWidget;

  late List<MenuItem> menuItems;

  ListCategoryWidget listCategoryWidget = ListCategoryWidget();
  ProductBrowseWidget productBrowseWidget = ProductBrowseWidget();
  ServiceBrowseWidget serviceBrowseWidget = ServiceBrowseWidget();
  PackageBrowseWidget packageBrowseWidget = PackageBrowseWidget();
  InspirationBrowseWidget inspirationBrowseWidget = InspirationBrowseWidget();

  User? user = GlobalController.instance.activeUser;

  @override
  void onInit() {
    super.onInit();
    menuItems = [
      MenuItem(
        id: "1",
        title: "All Products & Services",
        textStyle: TextStyle(color: Colors.black, fontSize: 18.sp, fontWeight: FontWeight.bold),
        data: listCategoryWidget,
      ),
      MenuItem(
        id: "1a",
        title: "Gaun dan Jas",
        textStyle: TextStyle(color: Colors.black, fontSize: 18.sp),
        prefix: SizedBox(width: 5.w),
        data: productBrowseWidget,
      ),
      MenuItem(
        id: "1b",
        title: "Make Up",
        textStyle: TextStyle(color: Colors.black, fontSize: 18.sp),
        prefix: SizedBox(width: 5.w),
        data: serviceBrowseWidget,
      ),
      MenuItem(
        id: "1c",
        title: "Fotografi",
        textStyle: TextStyle(color: Colors.black, fontSize: 18.sp),
        prefix: SizedBox(width: 5.w),
        data: serviceBrowseWidget,
      ),
      MenuItem(
        id: "1d",
        title: "Lain-lain",
        textStyle: TextStyle(color: Colors.black, fontSize: 18.sp),
        prefix: SizedBox(width: 5.w),
        data: serviceBrowseWidget,
      ),
      MenuItem(
        id: "2",
        title: "Paket / Bundle",
        textStyle: TextStyle(color: Colors.black, fontSize: 18.sp, fontWeight: FontWeight.bold),
        data: packageBrowseWidget,
      ),
      MenuItem(
        id: "3",
        title: "Inspirations",
        textStyle: TextStyle(color: Colors.black, fontSize: 18.sp, fontWeight: FontWeight.bold),
        data: inspirationBrowseWidget,
      ),
    ];
  }
}
