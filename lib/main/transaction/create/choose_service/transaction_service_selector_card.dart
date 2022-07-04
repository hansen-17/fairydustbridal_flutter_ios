import '../../../../utils/global_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../models/transaction.dart';
import '../../../../utils/app_color.dart';
import '../../../../utils/size_util.dart';
import '../create_transaction_viewmodel.dart';
import 'transaction_service_bottomsheet.dart';

class TransactionServiceSelectorCard extends StatelessWidget {
  final DetailTransactionService detailTransactionService;
  TransactionServiceSelectorCard({required this.detailTransactionService});

  final CreateTransactionViewModel createTransactionViewModel = Get.find<CreateTransactionViewModel>();

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${detailTransactionService.service.type?.name}",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                ),
                Text(
                  "${detailTransactionService.service.description}",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                ),
                SizedBox(height: 0.25.h),
                Text(
                  "(${DateFormat("dd MMM yyyy").format(detailTransactionService.beginDate)} - ${DateFormat("dd MMM yyyy").format(detailTransactionService.endDate)})",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 11.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                ),
                Expanded(child: Container()),
                Row(
                  children: [
                    InkWell(
                      onTap: () => Get.bottomSheet(TransactionServiceBottomSheet(detailTransactionService: detailTransactionService)),
                      borderRadius: BorderRadius.circular(2.h),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          border: Border.all(width: 0.1.w),
                          borderRadius: BorderRadius.circular(2.h),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.edit, color: AppColor.primary, size: 14.sp),
                            SizedBox(width: 1.w),
                            Text("Edit", style: TextStyle(color: AppColor.primary, fontSize: 11.sp, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    InkWell(
                      onTap: () => createTransactionViewModel.removeDetailService(detailTransactionService),
                      borderRadius: BorderRadius.circular(2.h),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          border: Border.all(width: 0.1.w),
                          borderRadius: BorderRadius.circular(2.h),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.remove_circle, color: Colors.red, size: 14.sp),
                            SizedBox(width: 1.w),
                            Text("Remove", style: TextStyle(color: Colors.red, fontSize: 11.sp, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 0.25.h),
              ],
            ),
          ),
          SizedBox(width: 0.25.w),
          Container(
            width: GlobalController.instance.isPhone ? 20.w : 15.w,
            height: GlobalController.instance.isPhone ? 20.w : 15.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(1.h),
              image: DecorationImage(
                image: Image.network(detailTransactionService.service.photo!.photoUrl).image,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
