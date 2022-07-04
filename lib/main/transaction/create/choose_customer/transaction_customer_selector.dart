import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/app_color.dart';
import '../../../../utils/size_util.dart';
import '../create_transaction_viewmodel.dart';
import 'transaction_customer_bottomsheet.dart';

class TransactionCustomerSelector extends StatelessWidget {
  final CreateTransactionViewModel createTransactionViewModel = Get.find<CreateTransactionViewModel>();
  final bool isEnabled;
  TransactionCustomerSelector({required this.isEnabled});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Customer",
              style: TextStyle(color: Colors.black, fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 1.5.h),
            TextFormField(
              controller: createTransactionViewModel.customerNameText,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(1.h), borderSide: BorderSide.none),
                contentPadding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                fillColor: AppColor.disabledBackground,
                filled: true,
                hintStyle: TextStyle(color: AppColor.disabled, fontSize: 12.sp),
                hintText: "Customer",
                prefixIcon: Icon(Icons.person),
                suffixIcon: IconButton(
                  onPressed: () => Get.bottomSheet(TransactionCustomerBottomSheet()),
                  icon: Icon(Icons.search),
                ),
              ),
              enabled: isEnabled,
              readOnly: true,
              style: TextStyle(color: Colors.black, fontSize: 12.sp, fontWeight: FontWeight.bold),
              textInputAction: TextInputAction.next,
              validator: (str) {},
            ),
          ],
        ),
      ),
    );
  }
}
