import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../models/user.dart';

class StorageService extends GetxService {
  static get me => Get.find<StorageService>();

  GetStorage getStorage = GetStorage();

  Future<StorageService> initStorage() async {
    await GetStorage.init();
    return this;
  }

  void setUsertoStorage(User? user) {
    if (user == null) {
      getStorage.remove("user");
    } else {
      getStorage.write("user", user.toJson());
    }
  }

  User? getUserFromStorage() {
    Map<String, dynamic>? userJson = getStorage.read<Map<String, dynamic>>("user");
    if (userJson != null) {
      User user = User.fromJson(userJson);
      return user;
    }
  }
}
