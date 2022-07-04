import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/transaction.dart';
import '../../../utils/size_util.dart';
import 'transaction_viewmodel.dart';

class PastTransactionCard extends StatelessWidget {
  final Transaction transaction;
  PastTransactionCard({required this.transaction});

  final TransactionViewModel transactionViewModel = Get.find<TransactionViewModel>();

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
            Text(
              transaction.customer.name,
              style: TextStyle(
                color: Colors.black,
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Divider(),
            ...transaction.transactionProducts
                .where(
                  (DetailTransactionProduct transactionProduct) => transactionProduct.rentDate == transactionViewModel.selectedDay,
                )
                .map(
                  (DetailTransactionProduct transactionProduct) => _buildProductList(transactionProduct),
                )
                .toList(),
            ...transaction.transactionServices
                .where(
                  (DetailTransactionService transactionService) => transactionService.beginDate == transactionViewModel.selectedDay,
                )
                .map(
                  (DetailTransactionService transactionService) => _buildServiceList(transactionService),
                )
                .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildProductList(DetailTransactionProduct transactionProduct) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 10.w,
            height: 10.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(1.h),
              image: DecorationImage(
                image: Image.network(transactionProduct.product.photos[0].photoUrl).image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                transactionProduct.product.code,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                transactionProduct.rentDate == transactionViewModel.selectedDay ? "Rented Today" : "Returned Today",
                // "(${DateFormat("dd MMM yyyy").format(transactionProduct.rentDate)} - ${DateFormat("dd MMM yyyy").format(transactionProduct.returnDate)})",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 11.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServiceList(DetailTransactionService transactionService) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 10.w,
            height: 10.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(1.h),
              image: DecorationImage(
                image: Image.network(transactionService.service.photo?.photoUrl ?? "").image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                transactionService.service.description,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                transactionService.beginDate == transactionViewModel.selectedDay ? "Start Today" : "Finish Today",
                // "(${DateFormat("dd MMM yyyy").format(transactionService.beginDate)} - ${DateFormat("dd MMM yyyy").format(transactionService.endDate)})",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 11.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
