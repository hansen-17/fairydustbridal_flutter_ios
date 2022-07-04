import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../models/customer.dart';
import '../../../../utils/app_color.dart';
import '../../../../utils/size_util.dart';
import '../create_transaction_viewmodel.dart';

class TransactionCustomerCard extends StatelessWidget {
  final CreateTransactionViewModel createTransactionViewModel = Get.find<CreateTransactionViewModel>();

  final Customer customer;
  TransactionCustomerCard({required this.customer});

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
                      customer.name,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 0.25.h),
                    Text(
                      customer.instagram ?? "",
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
                    createTransactionViewModel.setCustomer(customer);
                    Get.back();
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
            Row(
              children: [
                Text("Phone Number : ", style: TextStyle(color: Colors.black, fontSize: 13.sp)),
                Text(customer.phoneNumber ?? "-", style: TextStyle(color: Colors.black, fontSize: 13.sp, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 1.h),
            Row(
              children: [
                Text("Email : ", style: TextStyle(color: Colors.black, fontSize: 13.sp)),
                Text(customer.email ?? "-", style: TextStyle(color: Colors.black, fontSize: 13.sp, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
