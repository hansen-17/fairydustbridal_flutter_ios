import 'package:get/get.dart';

import '../../../../../models/product.dart';
import '../../../../../utils/api_service.dart';

class ProductDetailViewModel extends GetxController {
  late Product _product;
  Product get product => _product;

  bool _loadingInfo = false;
  bool get isLoadingInfo => _loadingInfo;
  void triggerLoadingInfo() {
    _loadingInfo = !_loadingInfo;
    update();
  }

  List<DateTime> _blackOutDates = [];
  List<DateTime> get blackOutDates => _blackOutDates;

  @override
  void onInit() {
    super.onInit();
    _product = Get.arguments;
    loadProductInfo();
  }

  Future<void> loadProductInfo() async {
    triggerLoadingInfo();
    dynamic result = (await ApiService.me.get("master/product/${_product.id}")).body;
    triggerLoadingInfo();

    if (result != null) {
      dynamic data = result["data"]["transaction"];
      data.forEach((datum) {
        DateTime rentDate = DateTime.parse(datum["rent_date"]);
        DateTime returnDate = DateTime.parse(datum["return_date"]);

        for (int i = 0; i <= returnDate.difference(rentDate).inDays; i++) {
          _blackOutDates.add(rentDate.add(Duration(days: i)));
        }
      });
    }

    update();
  }
}
