import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';

class ProductPhotoScreen extends StatelessWidget {
  final String url = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: PhotoView(
          imageProvider: Image.network(url, fit: BoxFit.cover).image,
        ),
      ),
    );
  }
}
