import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../models/service.dart';
import '../../../../utils/app_color.dart';
import '../../../../utils/size_util.dart';
import 'transaction_service_viewmodel.dart';

class TransactionServiceCard extends StatelessWidget {
  final TransactionServiceViewModel transactionServiceViewModel = Get.find<TransactionServiceViewModel>();

  final Service service;
  TransactionServiceCard({required this.service});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.25.h,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1.h)),
      child: Container(
        width: 100.w,
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(right: 2.5.w),
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(1.h),
                image: DecorationImage(
                  image: Image.network(service.photo!.photoUrl).image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.description,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 0.25.h),
                  Text(
                    "${service.type!.name}",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12.sp,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                      onPressed: () {
                        transactionServiceViewModel.setSelectedService(service);
                        transactionServiceViewModel.carouselController.nextPage();
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
