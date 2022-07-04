import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../models/transaction.dart';
import '../../../utils/app_color.dart';
import '../../../utils/size_util.dart';
import 'transaction_viewmodel.dart';

class TransactionCard extends StatelessWidget {
  final TransactionViewModel transactionViewModel = Get.find<TransactionViewModel>();

  final Transaction transaction;
  TransactionCard({required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.5.h,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1.h)),
      child: Container(
        width: 100.w,
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.customer.name,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      DateFormat("dd MMM yyyy").format(transaction.transactionDate),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
                PopupMenuButton(
                  onSelected: (value) {
                    switch (value) {
                      case "Edit":
                        Get.toNamed("/create-transaction", arguments: transaction);
                        break;
                      case "Delete":
                        Get.dialog(
                          AlertDialog(
                            title: Text("Delete Confirmation"),
                            content: Text("Delete this transaction?"),
                            actions: [
                              TextButton(onPressed: () => Get.back(), child: Text("Cancel")),
                              TextButton(
                                onPressed: () {
                                  transactionViewModel.deleteTransaction(transaction);
                                  Get.back();
                                },
                                child: Text("OK"),
                              ),
                            ],
                          ),
                        );
                        break;
                    }
                  },
                  iconSize: 5.w,
                  itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                    PopupMenuItem<String>(
                      value: "Edit",
                      child: Text(
                        "Edit",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 13.sp,
                        ),
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: "Delete",
                      child: Text(
                        "Delete",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 13.sp,
                        ),
                      ),
                    ),
                  ],
                  icon: Icon(Icons.more_vert),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
            Divider(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 10.w,
                  height: 10.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(1.h),
                    image: DecorationImage(
                      image: Image.network(transaction.firstPhotoUrl).image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.firstItemName,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      transaction.firstDates,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 1.h),
            transaction.totalItems > 1
                ? Text(
                    "+ ${transaction.totalItems - 1} other item(s)",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12.sp,
                    ),
                  )
                : Container(),
            SizedBox(height: 1.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 10.sp,
                      ),
                    ),
                    SizedBox(height: 0.25.h),
                    Text(
                      "Rp ${NumberFormat("#,###").format(transaction.grandTotal)}".replaceAll(",", "."),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () async {
                    SmartDialog.showLoading(msg: "Loading...");
                    await transactionViewModel.printPdf(transaction);
                    SmartDialog.dismiss();
                  },
                  child: Text(
                    "Print",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.25.h),
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
          ],
        ),
      ),
    );
  }
}
