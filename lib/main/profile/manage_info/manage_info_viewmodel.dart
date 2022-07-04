import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/api_service.dart';

class ManageInfoViewModel extends GetxController {
  bool _loadingInit = false;
  bool get isLoadingInit => _loadingInit;
  void triggerLoadingInit() {
    _loadingInit = !_loadingInit;
    update();
  }

  bool _loadingSave = false;
  bool get isLoadingSave => _loadingSave;
  void triggerLoadingSave() {
    _loadingSave = !_loadingSave;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    loadAbout();
  }

  bool _validate = false;
  bool get isStartValidating => _validate;
  void startValidation() {
    if (!_validate) _validate = true;
  }

  TextEditingController headerText = TextEditingController(text: "");
  String? validateHeader() {
    if (!_validate) return null;
    return null;
  }

  TextEditingController descriptionText = TextEditingController(text: "");
  String? validateDescription() {
    if (!_validate) return null;
    return null;
  }

  TextEditingController whatsappText = TextEditingController(text: "");
  String? validateWhatsapp() {
    if (!_validate) return null;
    return null;
  }

  TextEditingController facebookText = TextEditingController(text: "");
  String? validateFacebook() {
    if (!_validate) return null;
    return null;
  }

  TextEditingController instagramText = TextEditingController(text: "");
  String? validateInstagram() {
    if (!_validate) return null;
    return null;
  }

  Future<void> updateAbout() async {
    triggerLoadingSave();
    Map<String, dynamic> body = {
      "header": headerText.text,
      "description": descriptionText.text,
      "whatsapp": whatsappText.text,
      "facebook": facebookText.text,
      "instagram": instagramText.text,
      "email": "fairydustbridal@gmail.com",
    };

    dynamic result = (await ApiService.me.put("master/about-us", body)).body;
    triggerLoadingSave();

    if (result != null) Get.back();
  }

  Future<void> loadAbout() async {
    triggerLoadingInit();
    dynamic result = (await ApiService.me.get("master/about-us")).body;
    triggerLoadingInit();

    if (result != null) {
      headerText.text = result["data"]["header"];
      descriptionText.text = result["data"]["description"];
      whatsappText.text = result["data"]["whatsapp"];
      facebookText.text = result["data"]["facebook"];
      instagramText.text = result["data"]["instagram"];
    }
  }
}
