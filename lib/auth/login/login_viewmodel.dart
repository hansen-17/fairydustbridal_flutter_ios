import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/user.dart';
import '../../utils/api_service.dart';
import '../../utils/global_controller.dart';

class LoginViewModel extends GetxController {
  bool _loading = false;
  bool get isLoading => _loading;
  void triggerLoading() {
    _loading = !_loading;
    update();
  }

  bool _validate = false;
  bool get isStartValidating => _validate;
  void startValidation() {
    if (!_validate) _validate = true;
  }

  TextEditingController emailText = TextEditingController(text: "fairydustbridal@gmail.com");
  String? validateEmail() {
    if (!_validate) return null;
    if (emailText.text.isEmpty) return "Email cannot be empty!";
    if (!(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(emailText.text))) return "Please enter a valid email!";
    return null;
  }

  TextEditingController passwordText = TextEditingController(text: "12345678");
  String? validatePassword() {
    if (!_validate) return null;
    if (passwordText.text.isEmpty) return "Password cannot be empty!";
    return null;
  }

  Future<void> login() async {
    triggerLoading();
    Map<String, dynamic> body = {
      "email": emailText.text,
      "password": passwordText.text,
    };

    dynamic result = (await ApiService.me.post("auth/login", body)).body;
    triggerLoading();

    if (result != null) {
      User user = User.fromJson(result["data"]);
      GlobalController.instance.setActiveUser(user);
      await getMyProfile();
    }
  }

  Future<void> getMyProfile() async {
    dynamic result = (await ApiService.me.get("auth/me")).body;
    if (result != null) {
      GlobalController.instance.setUserInfo(result["data"]["id"], result["data"]["email"], result["data"]["email_verified_at"] == null);
    }
    Get.offNamed("/main");
  }

  void loginAsGuest() {
    GlobalController.instance.setActiveUser(null);
    Get.offNamed("/main");
  }
}
