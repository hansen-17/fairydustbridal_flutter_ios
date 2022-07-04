import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/size_util.dart';

class InspirationCard extends StatelessWidget {
  final String photoUrl;
  InspirationCard({required this.photoUrl});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          elevation: 0.5.h,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1.h)),
          child: Material(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(1.h)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(1.h),
                        image: DecorationImage(
                          image: Image.network(photoUrl).image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Container(
            padding: EdgeInsets.all(0.5.h),
            child: Material(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1.h)),
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(1.h),
                onTap: () {
                  Get.toNamed("/service-photo", arguments: photoUrl);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
