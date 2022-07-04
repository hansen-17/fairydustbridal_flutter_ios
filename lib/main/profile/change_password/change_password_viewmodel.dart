import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/api_service.dart';
import '../../../utils/global_controller.dart';

class ChangePasswordViewModel extends GetxController {
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

  TextEditingController currentPasswordText = TextEditingController(text: "");
  String? validateCurrentPassword() {
    if (!_validate) return null;
    if (currentPasswordText.text.isEmpty) return "Password cannot be empty!";
    return null;
  }

  TextEditingController newPasswordText = TextEditingController(text: "");
  String? validateNewPassword() {
    if (!_validate) return null;
    if (newPasswordText.text.length < 6) return "Password is too short!";
    if (newPasswordText.text.isEmpty) return "Password cannot be empty!";
    return null;
  }

  TextEditingController confirmNewPasswordText = TextEditingController(text: "");
  String? validateConfirmNewPassword() {
    if (!_validate) return null;
    if (confirmNewPasswordText.text.length < 6) return "Password is too short!";
    if (confirmNewPasswordText.text.isEmpty) return "Password cannot be empty!";
    if (confirmNewPasswordText.text != newPasswordText.text) return "Password doesn't match!";
    return null;
  }

  Future<void> changePassword() async {
    triggerLoading();
    Map<String, dynamic> body = {
      "current_password": currentPasswordText.text,
      "new_password": newPasswordText.text,
      "new_password_confirmation": confirmNewPasswordText.text,
    };

    dynamic result = (await ApiService.me.put("master/user/${GlobalController.instance.activeUser!.id}", body)).body;
    triggerLoading();

    if (result != null) Get.back();
  }
}
