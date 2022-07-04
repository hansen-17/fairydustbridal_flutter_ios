import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/app_color.dart';
import '../../../utils/size_util.dart';
import 'transaction_viewmodel.dart';

class TransactionDisplayToggle extends StatelessWidget {
  final TransactionViewModel transactionViewModel = Get.find<TransactionViewModel>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TransactionViewModel>(builder: (_) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w),
        child: Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () => transactionViewModel.toggleDisplayTo(DisplayType.TODAY),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    toggleCheckmark(DisplayType.TODAY),
                    Text(
                      "Today's Transactions",
                      style: TextStyle(color: toggleColorForeground(DisplayType.TODAY), fontSize: 12.sp, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                style: TextButton.styleFrom(
                  backgroundColor: toggleColorBackground(DisplayType.TODAY),
                  elevation: 0.5.h,
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  primary: AppColor.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1.h)),
                  shadowColor: Color.fromARGB(255, 208, 239, 230),
                ),
              ),
            ),
            SizedBox(width: 2.5.w),
            Expanded(
              child: TextButton(
                onPressed: () => transactionViewModel.toggleDisplayTo(DisplayType.PAST),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  toggleCheckmark(DisplayType.PAST),
                  Text(
                    "Past Transactions",
                    style: TextStyle(color: toggleColorForeground(DisplayType.PAST), fontSize: 12.sp, fontWeight: FontWeight.bold),
                  ),
                ]),
                style: TextButton.styleFrom(
                  backgroundColor: toggleColorBackground(DisplayType.PAST),
                  elevation: 0.5.h,
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  primary: AppColor.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1.h)),
                  shadowColor: Color.fromARGB(255, 208, 239, 230),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget toggleCheckmark(DisplayType displayType) => transactionViewModel.selectedDisplay == displayType ? Container(child: Icon(Icons.check, size: 12.sp, color: Colors.white), margin: EdgeInsets.only(right: 1.w)) : Container();
  Color toggleColorBackground(DisplayType displayType) => transactionViewModel.selectedDisplay == displayType ? AppColor.primary : Colors.white;
  Color toggleColorForeground(DisplayType displayType) => transactionViewModel.selectedDisplay == displayType ? Colors.white : AppColor.primary;
}
