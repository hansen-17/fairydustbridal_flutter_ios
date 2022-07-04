import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/app_color.dart';
import '../../../../utils/size_util.dart';
import '../create_transaction_viewmodel.dart';
import 'transaction_product_bottomsheet.dart';
import 'transaction_product_selector_card.dart';

class TransactionProductSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: 100.w,
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 4.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GetBuilder<CreateTransactionViewModel>(
              builder: (createTransactionViewModel) {
                if (createTransactionViewModel.detailTransactionProducts.length == 0) {
                  return Container(
                    width: 100.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.block, color: Colors.grey, size: 22.sp),
                        SizedBox(height: 0.5.h),
                        Text(
                          "No Product Added",
                          style: TextStyle(color: Colors.grey, fontSize: 11.sp, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  itemBuilder: (context, index) => TransactionProductSelectorCard(detailTransactionProduct: createTransactionViewModel.detailTransactionProducts[index]),
                  itemCount: createTransactionViewModel.detailTransactionProducts.length,
                  physics: NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) => SizedBox(height: 3.h, child: Divider()),
                  shrinkWrap: true,
                );
              },
            ),
            SizedBox(height: 4.h),
            GestureDetector(
              onTap: () => Get.bottomSheet(TransactionProductBottomSheet(detailTransactionProduct: null)),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, size: 17.sp, color: AppColor.primary),
                    SizedBox(width: 1.w),
                    Text(
                      "Add Product",
                      style: TextStyle(color: AppColor.primary, fontSize: 14.sp, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
