import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../models/photo.dart';
import '../../../../../models/product.dart';
import '../../../../../utils/app_color.dart';
import '../../../../../utils/size_util.dart';

class SearchProductCard extends StatelessWidget {
  final Product product;
  SearchProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.25.h,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1.h)),
      child: Container(
        width: 100.w,
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.code,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 0.25.h),
                    Text(
                      "${product.type.name} (${product.category.name})",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.sp,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    Get.toNamed("/product-detail", arguments: product);
                  },
                  child: Text(
                    "Select",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    primary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(1.h),
                      side: BorderSide(color: AppColor.primary),
                    ),
                    shadowColor: Color.fromARGB(255, 208, 239, 230),
                  ),
                ),
              ],
            ),
            Divider(),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: product.photos.map(
                  (Photo photo) {
                    return Container(
                      margin: EdgeInsets.only(right: 2.5.w),
                      width: 15.w,
                      height: 15.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(1.h),
                        image: DecorationImage(
                          image: Image.network(photo.photoUrl).image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
