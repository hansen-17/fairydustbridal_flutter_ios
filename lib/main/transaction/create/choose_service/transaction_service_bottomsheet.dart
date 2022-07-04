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
import 'transaction_service_card.dart';
import 'transaction_service_viewmodel.dart';

class TransactionServiceBottomSheet extends StatelessWidget {
  TransactionServiceBottomSheet({DetailTransactionService? detailTransactionService}) {
    transactionServiceViewModel.detailTransactionService = detailTransactionService;
    if (detailTransactionService != null) transactionServiceViewModel.setSelectedService(detailTransactionService.service);
    transactionServiceViewModel.getServices();
  }

  final TransactionServiceViewModel transactionServiceViewModel = Get.put(TransactionServiceViewModel());

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
        carouselController: transactionServiceViewModel.carouselController,
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
          _TransactionServiceFirstPage(),
          _TransactionServiceSecondPage(),
        ],
      ),
    );
  }
}

class _TransactionServiceFirstPage extends StatelessWidget {
  final TransactionServiceViewModel transactionServiceViewModel = Get.put(TransactionServiceViewModel());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 1.w),
          child: Text("Search by name :", style: TextStyle(color: Colors.black, fontSize: 12.sp)),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: transactionServiceViewModel.serviceNameText,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(1.h), borderSide: BorderSide.none),
            contentPadding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            fillColor: AppColor.disabledBackground,
            filled: true,
            hintStyle: TextStyle(color: AppColor.disabled, fontSize: 12.sp),
            hintText: "Service Name",
          ),
          onChanged: (_) {
            if (transactionServiceViewModel.debounce?.isActive ?? false) transactionServiceViewModel.debounce!.cancel();
            transactionServiceViewModel.debounce = Timer(const Duration(milliseconds: 500), () {
              transactionServiceViewModel.getServices();
            });
          },
          style: TextStyle(color: Colors.black, fontSize: 12.sp, fontWeight: FontWeight.bold),
          textInputAction: TextInputAction.done,
        ),
        SizedBox(height: 2.h),
        Expanded(
          child: GetBuilder<TransactionServiceViewModel>(
            builder: (_) {
              if (transactionServiceViewModel.isLoadingServices) return Center(child: Container(width: 5.w, height: 5.w, child: CircularProgressIndicator()));

              return LazyLoadScrollView(
                onEndOfPage: () => transactionServiceViewModel.loadMoreServices(),
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    if (transactionServiceViewModel.services[index].id == "") return Center(child: Container(width: 5.w, height: 5.w, child: CircularProgressIndicator()));

                    return TransactionServiceCard(service: transactionServiceViewModel.services[index]);
                  },
                  separatorBuilder: (context, index) => SizedBox(height: 1.h),
                  itemCount: transactionServiceViewModel.services.length,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _TransactionServiceSecondPage extends StatelessWidget {
  final CreateTransactionViewModel createTransactionViewModel = Get.find<CreateTransactionViewModel>();
  final TransactionServiceViewModel transactionServiceViewModel = Get.put(TransactionServiceViewModel());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 1.w),
          child: Text(
            "Service Name : ${transactionServiceViewModel.selectedService?.description}",
            style: TextStyle(color: Colors.black, fontSize: 12.sp, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(width: double.infinity, height: 1.h),
        Expanded(
          child: GetBuilder<TransactionServiceViewModel>(
            builder: (_) {
              if (transactionServiceViewModel.isLoadingInfo) return Center(child: Container(width: 5.w, height: 5.w, child: CircularProgressIndicator()));

              return SfDateRangePicker(
                allowViewNavigation: false,
                controller: transactionServiceViewModel.dateRangePickerController,
                headerStyle: DateRangePickerHeaderStyle(
                  textStyle: TextStyle(
                    color: Colors.black,
                    fontFamily: "ProximaNova",
                  ),
                ),
                monthViewSettings: DateRangePickerMonthViewSettings(blackoutDates: []),
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
              if (transactionServiceViewModel.dateRangePickerController.selectedRange == null)
                return Get.snackbar(
                  "Invalid Date",
                  "Please choose a valid date range first!",
                  messageText: Text("Please choose a valid date range first!", style: TextStyle(fontStyle: FontStyle.italic)),
                  margin: EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
                  snackPosition: SnackPosition.BOTTOM,
                );

              if (transactionServiceViewModel.detailTransactionService == null) {
                createTransactionViewModel.addDetailService(
                  service: transactionServiceViewModel.selectedService!,
                  beginDate: transactionServiceViewModel.beginDate,
                  endDate: transactionServiceViewModel.endDate,
                  description: "",
                );
              } else {
                createTransactionViewModel.updateDetailService(
                  detailTransactionService: transactionServiceViewModel.detailTransactionService!,
                  service: transactionServiceViewModel.selectedService!,
                  beginDate: transactionServiceViewModel.beginDate,
                  endDate: transactionServiceViewModel.endDate,
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
