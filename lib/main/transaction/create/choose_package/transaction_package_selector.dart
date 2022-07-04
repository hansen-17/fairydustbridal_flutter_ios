import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/app_color.dart';
import '../../../../utils/size_util.dart';
import '../create_transaction_viewmodel.dart';
import 'transaction_package_bottomsheet.dart';

class TransactionPackageSelector extends StatelessWidget {
  final CreateTransactionViewModel createTransactionViewModel = Get.find<CreateTransactionViewModel>();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Package",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 1.5.h),
            TextFormField(
              controller: createTransactionViewModel.packageNameText,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(1.h), borderSide: BorderSide.none),
                contentPadding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                fillColor: AppColor.disabledBackground,
                filled: true,
                hintStyle: TextStyle(color: AppColor.disabled, fontSize: 12.sp),
                hintText: "Package",
                prefixIcon: Icon(Icons.auto_awesome_motion),
                suffixIcon: IconButton(
                  onPressed: () => Get.bottomSheet(TransactionPackageBottomSheet()),
                  icon: Icon(Icons.search),
                ),
              ),
              readOnly: true,
              style: TextStyle(color: Colors.black, fontSize: 12.sp, fontWeight: FontWeight.bold),
              textInputAction: TextInputAction.next,
              validator: (str) {},
            ),
            SizedBox(height: 0.5.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 1.w),
              child: Container(
                width: 100.w,
                child: Text(
                  "*Selecting Package will reset all unsaved data below",
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
