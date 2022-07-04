import 'package:get/get.dart';

import '../models/user.dart';
import 'api_service.dart';
import 'storage_service.dart';

class GlobalController extends GetxController {
  static GlobalController get instance => Get.find<GlobalController>();

  ApiService apiService = Get.find<ApiService>();
  StorageService storageService = Get.find<StorageService>();

  User? _activeUser;
  User? get activeUser => _activeUser;
  void setActiveUser(User? user) {
    _activeUser = user;
    if (_activeUser == null) {
      storageService.setUsertoStorage(null);
      apiService.detachToken();
    } else {
      storageService.setUsertoStorage(_activeUser);
      apiService.attachToken(_activeUser!.token);
    }
  }

  void setUserInfo(String id, String email, bool isEmailVerified) {
    if (_activeUser == null) return;
    _activeUser!.id = id;
    _activeUser!.email = email;
    _activeUser!.isEmailVerified = isEmailVerified;
    storageService.setUsertoStorage(_activeUser);
  }

  void setToken(String token) {
    if (_activeUser == null) return;
    _activeUser!.token = token;
    storageService.setUsertoStorage(_activeUser);
    apiService.attachToken(_activeUser!.token);
  }

  void getUserFromStorage() {
    _activeUser = storageService.getUserFromStorage();
    if (_activeUser != null) {
      ApiService.me.attachToken(_activeUser!.token);
    }
  }

  bool isPhone = true;
}
