import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../utils/app_color.dart';
import '../../../utils/loading_button.dart';
import '../../../utils/size_util.dart';
import 'choose_customer/transaction_customer_selector.dart';
import 'choose_package/transaction_package_selector.dart';
import 'choose_product/transaction_product_selector.dart';
import 'choose_service/transaction_service_selector.dart';
import 'create_transaction_viewmodel.dart';
import 'transaction_price_summary.dart';

class CreateTransactionScreen extends StatelessWidget {
  final CreateTransactionViewModel createTransactionViewModel = Get.put(CreateTransactionViewModel());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            createTransactionViewModel.isEdit ? "Edit Transaction" : "New Transaction",
            style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold),
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.fade,
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.only(
                  left: 3.w,
                  top: 2.h,
                  right: 3.w,
                ),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: Image.asset("assets/images/transaction-background.jpg").image,
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.white.withOpacity(0.95),
                      BlendMode.luminosity,
                    ),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TransactionCustomerSelector(
                            isEnabled: !createTransactionViewModel.isEdit,
                          ),
                          SizedBox(height: 2.h),
                          TransactionPackageSelector(),
                          SizedBox(height: 2.h),
                          TransactionProductSelector(),
                          SizedBox(height: 2.h),
                          TransactionServiceSelector(),
                          SizedBox(height: 2.h),
                          TransactionPriceSummary(),
                          SizedBox(height: 2.h),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 0.5.h,
                    blurRadius: 0.5.h,
                    offset: Offset(0, 3),
                  )
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "GRAND TOTAL",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GetBuilder<CreateTransactionViewModel>(
                        builder: (_) {
                          return Text(
                            "Rp ${NumberFormat("#,###").format(createTransactionViewModel.finalPrice).replaceAll(",", ".")}",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Down Payment",
                        style: TextStyle(
                          color: AppColor.primary,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GetBuilder<CreateTransactionViewModel>(
                        builder: (_) {
                          return Text(
                            "Rp ${createTransactionViewModel.downPaymentText.text}",
                            style: TextStyle(
                              color: AppColor.primary,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Container(
                    width: 100.w,
                    child: LoadingButton(
                      textButton: TextButton(
                        onPressed: () async {
                          await createTransactionViewModel.saveTransaction();
                        },
                        child: Text(
                          "Save Data",
                          style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.bold),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: AppColor.primary,
                          elevation: 0.5.h,
                          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.75.h),
                          primary: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1.h)),
                          shadowColor: Color.fromARGB(255, 208, 239, 230),
                        ),
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
