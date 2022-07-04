import 'package:get/get.dart';

import '../../models/user.dart';
import '../../utils/global_controller.dart';
import '../../utils/api_service.dart';

class ProfileViewModel extends GetxController {
  User? user = GlobalController.instance.activeUser;

  bool _loadingLogout = false;
  bool get isLoadingLogout => _loadingLogout;
  void triggerLoadingLogout() {
    _loadingLogout = !_loadingLogout;
    update();
  }

  bool _loadingDeactivate = false;
  bool get isLoadingDeactivate => _loadingDeactivate;
  void triggerLoadingDeactivate() {
    _loadingDeactivate = !_loadingDeactivate;
    update();
  }

  Future<void> logout() async {
    triggerLoadingLogout();
    await ApiService.me.post("auth/logout", {});
    triggerLoadingLogout();

    GlobalController.instance.setActiveUser(null);
    Get.offNamed("/login");
  }

  Future<void> deactivateAccount() async {
    triggerLoadingDeactivate();
    dynamic result = (await ApiService.me.delete("master/user/${GlobalController.instance.activeUser!.id}")).body;
    triggerLoadingDeactivate();

    if (result != null) {
      GlobalController.instance.setActiveUser(null);
      Get.offNamed("/login");
    }
  }
}
