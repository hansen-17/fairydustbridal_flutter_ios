import 'package:get/get.dart';

import '../utils/api_service.dart';
import '../utils/global_controller.dart';

class SplashViewModel extends GetxController {
  @override
  void onInit() {
    super.onInit();
    GlobalController.instance.getUserFromStorage();
    Future.delayed(Duration(milliseconds: 2500), () async => await navigateToNextScreen());
  }

  Future<void> navigateToNextScreen() async {
    if (GlobalController.instance.activeUser == null) {
      Get.offAllNamed("/login");
    } else {
      await refreshToken();
    }
  }

  Future<void> refreshToken() async {
    dynamic result = (await ApiService.me.post("auth/refresh", {})).body;
    if (result != null) {
      GlobalController.instance.setToken(result["data"]["access_token"]);
      await getMyProfile();
    } else {
      Get.offAllNamed("/login");
    }
  }

  Future<void> getMyProfile() async {
    dynamic result = (await ApiService.me.get("auth/me")).body;
    if (result != null) {
      GlobalController.instance.setUserInfo(result["data"]["id"], result["data"]["email"], result["data"]["email_verified_at"] == null);
      Get.offAllNamed("/main");
    } else {
      Get.offAllNamed("/login");
    }
  }
}
