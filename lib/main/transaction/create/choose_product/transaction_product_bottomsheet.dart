import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../../models/transaction.dart';
import '../../../../utils/app_color.dart';
import '../../../../utils/size_util.dart';
import '../create_transaction_viewmodel.dart';
import 'transaction_product_card.dart';
import 'transaction_product_viewmodel.dart';

class TransactionProductBottomSheet extends StatelessWidget {
  TransactionProductBottomSheet({DetailTransactionProduct? detailTransactionProduct}) {
    transactionProductViewModel.detailTransactionProduct = detailTransactionProduct;
    if (detailTransactionProduct != null) {
      transactionProductViewModel.setSelectedProduct(detailTransactionProduct.product);
      if (detailTransactionProduct.product.id != "") {
        transactionProductViewModel.productNameText.text = detailTransactionProduct.product.code;
      } else {
        transactionProductViewModel.productNameText.text = "";
      }
    }
    transactionProductViewModel.getProducts();
  }

  final TransactionProductViewModel transactionProductViewModel = Get.put(TransactionProductViewModel());

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      height: 60.h,
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(2.h), topRight: Radius.circular(2.h)),
        color: Colors.white,
      ),
      child: CarouselSlider(
        carouselController: transactionProductViewModel.carouselController,
        options: CarouselOptions(
          autoPlay: false,
          enableInfiniteScroll: false,
          enlargeCenterPage: false,
          height: 60.h,
          initialPage: 0,
          scrollPhysics: NeverScrollableScrollPhysics(),
          viewportFraction: 1,
        ),
        items: [
          _TransactionProductFirstPage(),
          _TransactionProductSecondPage(),
        ],
      ),
    );
  }
}

class _TransactionProductFirstPage extends StatelessWidget {
  final TransactionProductViewModel transactionProductViewModel = Get.put(TransactionProductViewModel());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 1.w),
          child: Text("Search by code :", style: TextStyle(color: Colors.black, fontSize: 12.sp)),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: transactionProductViewModel.productNameText,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(1.h), borderSide: BorderSide.none),
            contentPadding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            fillColor: AppColor.disabledBackground,
            filled: true,
            hintStyle: TextStyle(color: AppColor.disabled, fontSize: 12.sp),
            hintText: "Product Code",
          ),
          onChanged: (_) {
            if (transactionProductViewModel.debounce?.isActive ?? false) transactionProductViewModel.debounce!.cancel();
            transactionProductViewModel.debounce = Timer(const Duration(milliseconds: 500), () {
              transactionProductViewModel.getProducts();
            });
          },
          style: TextStyle(color: Colors.black, fontSize: 12.sp, fontWeight: FontWeight.bold),
          textInputAction: TextInputAction.done,
        ),
        SizedBox(height: 2.h),
        Expanded(
          child: GetBuilder<TransactionProductViewModel>(
            builder: (_) {
              if (transactionProductViewModel.isLoadingProducts) return Center(child: Container(width: 5.w, height: 5.w, child: CircularProgressIndicator()));

              return LazyLoadScrollView(
                onEndOfPage: () => transactionProductViewModel.loadMoreProducts(),
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    if (transactionProductViewModel.products[index].id == "") return Center(child: Container(width: 5.w, height: 5.w, child: CircularProgressIndicator()));

                    return TransactionProductCard(product: transactionProductViewModel.products[index]);
                  },
                  separatorBuilder: (context, index) => SizedBox(height: 1.h),
                  itemCount: transactionProductViewModel.products.length,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _TransactionProductSecondPage extends StatelessWidget {
  final CreateTransactionViewModel createTransactionViewModel = Get.find<CreateTransactionViewModel>();
  final TransactionProductViewModel transactionProductViewModel = Get.put(TransactionProductViewModel());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 1.w),
          child: Text(
            "Product Code : ${transactionProductViewModel.selectedProduct?.code}",
            style: TextStyle(color: Colors.black, fontSize: 12.sp, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(width: double.infinity, height: 1.h),
        Expanded(
          child: GetBuilder<TransactionProductViewModel>(
            builder: (_) {
              if (transactionProductViewModel.isLoadingInfo) return Center(child: Container(width: 5.w, height: 5.w, child: CircularProgressIndicator()));

              return SfDateRangePicker(
                allowViewNavigation: false,
                controller: transactionProductViewModel.dateRangePickerController,
                headerStyle: DateRangePickerHeaderStyle(
                  textStyle: TextStyle(
                    color: Colors.black,
                    fontFamily: "ProximaNova",
                  ),
                ),
                monthViewSettings: DateRangePickerMonthViewSettings(blackoutDates: transactionProductViewModel.blackOutDates, weekendDays: [7]),
                monthCellStyle: DateRangePickerMonthCellStyle(
                  blackoutDateTextStyle: TextStyle(color: AppColor.disabled),
                  textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  weekendTextStyle: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
                selectionMode: DateRangePickerSelectionMode.range,
              );
            },
          ),
        ),
        SizedBox(width: double.infinity, height: 1.h),
        Align(
          alignment: Alignment.bottomRight,
          child: TextButton(
            onPressed: () {
              if (transactionProductViewModel.dateRangePickerController.selectedRange == null)
                return Get.snackbar(
                  "Invalid Date",
                  "Please choose a valid date range first!",
                  messageText: Text("Please choose a valid date range first!", style: TextStyle(fontStyle: FontStyle.italic)),
                  margin: EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
                  snackPosition: SnackPosition.BOTTOM,
                );

              if (transactionProductViewModel.detailTransactionProduct == null) {
                createTransactionViewModel.addDetailProduct(
                  product: transactionProductViewModel.selectedProduct!,
                  rentDate: transactionProductViewModel.beginDate,
                  returnDate: transactionProductViewModel.endDate,
                  description: "",
                );
              } else {
                createTransactionViewModel.updateDetailProduct(
                  detailTransactionProduct: transactionProductViewModel.detailTransactionProduct!,
                  product: transactionProductViewModel.selectedProduct!,
                  rentDate: transactionProductViewModel.beginDate,
                  returnDate: transactionProductViewModel.endDate,
                  description: "",
                );
              }
              Get.back();
            },
            child: Text("Done", style: TextStyle(color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.bold)),
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
        ),
      ],
    );
  }
}
