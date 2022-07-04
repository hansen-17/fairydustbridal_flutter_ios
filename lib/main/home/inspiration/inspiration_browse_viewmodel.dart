import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/photo.dart';
import '../../../utils/api_service.dart';

class InspirationBrowseViewModel extends GetxController {
  late Offset tapPosition;

  bool _loading = false;
  bool get isLoading => _loading;
  void triggerLoading() {
    _loading = !_loading;
    update();
  }

  bool _folderView = true;
  bool get isFolderView => _folderView;
  void triggerView(Group? group) {
    _folderView = !_folderView;
    if (_folderView) {
      _selectedGroup = null;
    } else {
      _selectedGroup = group;
    }
    update();
  }

  List<Group> _groups = [];
  List<Group> get groups => _groups;

  Group? _selectedGroup;
  Group? get selectedGroup => _selectedGroup;

  @override
  void onInit() async {
    super.onInit();
    getPhotos();
  }

  Future<void> getPhotos({int page = 1}) async {
    _groups.clear();
    Map<String, dynamic> query = {
      "limit": "10000",
      "page": "$page",
    };

    triggerLoading();
    dynamic result = (await ApiService.me.get("master/gallery", query: query)).body;
    triggerLoading();

    if (result != null) {
      dynamic data = result["data"]["data"];
      data.forEach((datum) {
        _groups.add(Group.fromJson(datum));
      });
    }

    update();
  }

  Future<void> deleteGroup(Group group) async {
    dynamic result = (await ApiService.me.delete("master/gallery/${group.id}")).body;
    if (result != null) {
      _groups.remove(group);
      update();
    }
  }
}
