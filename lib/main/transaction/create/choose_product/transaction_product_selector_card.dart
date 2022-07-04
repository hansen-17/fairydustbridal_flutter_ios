import '../../../../utils/global_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../models/transaction.dart';
import '../../../../utils/app_color.dart';
import '../../../../utils/size_util.dart';
import '../create_transaction_viewmodel.dart';
import 'transaction_product_bottomsheet.dart';

class TransactionProductSelectorCard extends StatelessWidget {
  final DetailTransactionProduct detailTransactionProduct;
  TransactionProductSelectorCard({required this.detailTransactionProduct});

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
                  "${detailTransactionProduct.product.type.name} (${detailTransactionProduct.product.category.name}) ",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                ),
                Text(
                  "Code : ${detailTransactionProduct.product.code}",
                  style: TextStyle(
                    color: detailTransactionProduct.product.id == "" ? Colors.red : Colors.black,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                ),
                SizedBox(height: 0.25.h),
                Text(
                  "(${DateFormat("dd MMM yyyy").format(detailTransactionProduct.rentDate)} - ${DateFormat("dd MMM yyyy").format(detailTransactionProduct.returnDate)})",
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
                      onTap: () => Get.bottomSheet(TransactionProductBottomSheet(detailTransactionProduct: detailTransactionProduct)),
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
                      onTap: () => createTransactionViewModel.removeDetailProduct(detailTransactionProduct),
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
            decoration: detailTransactionProduct.product.photos.isEmpty
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(1.h),
                    color: AppColor.disabledBackground,
                  )
                : BoxDecoration(
                    borderRadius: BorderRadius.circular(1.h),
                    image: DecorationImage(
                      image: Image.network(detailTransactionProduct.product.photos[0].photoUrl).image,
                      fit: BoxFit.cover,
                    ),
                  ),
            child: detailTransactionProduct.product.photos.isEmpty
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 1.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          detailTransactionProduct.product.type.name,
                          style: TextStyle(color: AppColor.primary, fontSize: 12.sp, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          detailTransactionProduct.product.category.name,
                          style: TextStyle(color: AppColor.primary, fontSize: 12.sp, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : Container(),
          ),
        ],
      ),
    );
  }
}
