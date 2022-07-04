import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../utils/app_color.dart';
import '../../../utils/size_util.dart';
import 'past_transaction_card.dart';
import 'transaction_card.dart';
import 'transaction_day_picker.dart';
import 'transaction_display_toggle.dart';
import 'transaction_month_picker.dart';
import 'transaction_viewmodel.dart';

class TransactionFragment extends StatelessWidget {
  final TransactionViewModel transactionViewModel = Get.put(TransactionViewModel());
  final ItemScrollController itemScrollController = ItemScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(
          left: 5.w,
          top: SizeUtil.statusBarHeight() + 3.h,
          right: 5.w,
          bottom: 3.h,
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
        width: 100.w,
        height: 100.h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TransactionMonthPicker(itemScrollController: itemScrollController),
            SizedBox(height: 1.h),
            TransactionDayPicker(itemScrollController: itemScrollController),
            SizedBox(height: 3.h),
            Expanded(
              child: Column(
                children: [
                  TransactionDisplayToggle(),
                  SizedBox(height: 1.h),
                  GetBuilder<TransactionViewModel>(
                    builder: (_) {
                      return Expanded(
                        child: transactionViewModel.selectedDisplay == DisplayType.TODAY
                            ? (transactionViewModel.isLoading)
                                ? Center(child: Container(width: 5.w, height: 5.w, child: CircularProgressIndicator()))
                                : Stack(
                                    children: [
                                      transactionViewModel.transactions.length == 0
                                          ? Center(
                                              child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.list_alt, color: AppColor.disabled, size: 5.h),
                                                SizedBox(height: 1.h),
                                                Text("No Transactions", style: TextStyle(color: AppColor.disabled, fontSize: 13.sp, fontWeight: FontWeight.bold)),
                                              ],
                                            ))
                                          : Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 1.w),
                                              child: LazyLoadScrollView(
                                                onEndOfPage: () => transactionViewModel.loadMoreTransactions(),
                                                child: ListView.separated(
                                                  itemBuilder: (context, index) {
                                                    if (transactionViewModel.transactions[index].id == 0) return Center(child: Container(width: 5.w, height: 5.w, child: CircularProgressIndicator()));

                                                    return TransactionCard(transaction: transactionViewModel.transactions[index]);
                                                  },
                                                  itemCount: transactionViewModel.transactions.length,
                                                  padding: EdgeInsets.only(top: 1.h, bottom: 5.h),
                                                  separatorBuilder: (context, index) => SizedBox(height: 2.h),
                                                ),
                                              ),
                                            ),
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: FloatingActionButton(
                                          onPressed: () => Get.toNamed("/create-transaction"),
                                          backgroundColor: AppColor.primary,
                                          child: Icon(Icons.add),
                                        ),
                                      ),
                                    ],
                                  )
                            : Padding(
                                padding: EdgeInsets.symmetric(horizontal: 1.w),
                                child: ListView.separated(
                                  itemBuilder: (context, index) {
                                    if (transactionViewModel.transactions[index].id == 0) return Center(child: Container(width: 5.w, height: 5.w, child: CircularProgressIndicator()));

                                    return PastTransactionCard(transaction: transactionViewModel.transactions[index]);
                                  },
                                  itemCount: transactionViewModel.transactions.length,
                                  padding: EdgeInsets.symmetric(vertical: 1.h),
                                  separatorBuilder: (context, index) => SizedBox(height: 2.h),
                                ),
                              ),
                      );
                    },
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
