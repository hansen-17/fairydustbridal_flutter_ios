import 'package:get/get.dart';

import '../../../utils/api_service.dart';

class AboutViewModel extends GetxController {
  bool _loading = false;
  bool get isLoading => _loading;
  void triggerLoading() {
    _loading = !_loading;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    loadAbout();
  }

  String header = "";
  String description = "";
  String whatsapp = "";
  String facebook = "";
  String instagram = "";

  Future<void> loadAbout() async {
    triggerLoading();
    dynamic result = (await ApiService.me.get("master/about-us")).body;
    triggerLoading();

    if (result != null) {
      header = result["data"]["header"];
      description = result["data"]["description"];
      whatsapp = result["data"]["whatsapp"];
      facebook = result["data"]["facebook"];
      instagram = result["data"]["instagram"];
    }
  }
}
