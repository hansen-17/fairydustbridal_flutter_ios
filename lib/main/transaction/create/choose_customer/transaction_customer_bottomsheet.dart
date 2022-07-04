import 'dart:async';

import '../../../../utils/loading_button.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

import '../../../../utils/app_color.dart';
import '../../../../utils/size_util.dart';
import 'transaction_customer_card.dart';
import 'transaction_customer_viewmodel.dart';

class TransactionCustomerBottomSheet extends StatelessWidget {
  final TransactionCustomerViewModel transactionCustomerViewModel = Get.put(TransactionCustomerViewModel());

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
        carouselController: transactionCustomerViewModel.carouselController,
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
          _TransactionCustomerFirstPage(),
          _TransactionCustomerSecondPage(),
        ],
      ),
    );
  }
}

class _TransactionCustomerFirstPage extends StatelessWidget {
  final TransactionCustomerViewModel transactionCustomerViewModel = Get.put(TransactionCustomerViewModel());

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
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: TextFormField(
                  controller: transactionCustomerViewModel.customerNameText,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(1.h), borderSide: BorderSide.none),
                    contentPadding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    fillColor: AppColor.disabledBackground,
                    filled: true,
                    hintStyle: TextStyle(color: AppColor.disabled, fontSize: 12.sp),
                    hintText: "Customer Name",
                  ),
                  onChanged: (_) {
                    if (transactionCustomerViewModel.debounce?.isActive ?? false) transactionCustomerViewModel.debounce!.cancel();
                    transactionCustomerViewModel.debounce = Timer(const Duration(milliseconds: 500), () {
                      transactionCustomerViewModel.getCustomers();
                    });
                  },
                  style: TextStyle(color: Colors.black, fontSize: 12.sp, fontWeight: FontWeight.bold),
                  textInputAction: TextInputAction.done,
                ),
              ),
              SizedBox(width: 2.5.w),
              TextButton(
                onPressed: () {
                  transactionCustomerViewModel.carouselController.nextPage();
                },
                child: Text(
                  "+",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: AppColor.primary,
                  padding: EdgeInsets.symmetric(horizontal: 0.5.w, vertical: 0.5.h),
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
        ),
        SizedBox(height: 2.h),
        Expanded(
          child: GetBuilder<TransactionCustomerViewModel>(
            builder: (_) {
              if (transactionCustomerViewModel.isLoadingCustomers) return Center(child: Container(width: 5.w, height: 5.w, child: CircularProgressIndicator()));

              return LazyLoadScrollView(
                onEndOfPage: () => transactionCustomerViewModel.loadMoreCustomers(),
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    if (transactionCustomerViewModel.customers[index].id == "") return Center(child: Container(width: 5.w, height: 5.w, child: CircularProgressIndicator()));

                    return TransactionCustomerCard(
                      customer: transactionCustomerViewModel.customers[index],
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(height: 1.h),
                  itemCount: transactionCustomerViewModel.customers.length,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _TransactionCustomerSecondPage extends StatelessWidget {
  final TransactionCustomerViewModel transactionCustomerViewModel = Get.put(TransactionCustomerViewModel());
  final GlobalKey<FormState> _newCustomerFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _newCustomerFormKey,
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Adding New Customer", style: TextStyle(color: Colors.black, fontSize: 12.sp)),
                  SizedBox(height: 2.h),
                  Text("Customer's Name", style: TextStyle(color: Colors.black, fontSize: 13.sp)),
                  SizedBox(height: 0.5.h),
                  TextFormField(
                    controller: transactionCustomerViewModel.newCustomerNameText,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(1.h), borderSide: BorderSide.none),
                      contentPadding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                      fillColor: AppColor.disabledBackground,
                      filled: true,
                      hintStyle: TextStyle(color: AppColor.disabled, fontSize: 12.sp),
                      hintText: "Customer's Name",
                    ),
                    onChanged: (_) => _newCustomerFormKey.currentState!.validate(),
                    style: TextStyle(color: Colors.black, fontSize: 12.sp, fontWeight: FontWeight.bold),
                    textInputAction: TextInputAction.done,
                    validator: (str) => transactionCustomerViewModel.validateName(),
                  ),
                  SizedBox(height: 2.h),
                  Text("Customer's Instagram Account", style: TextStyle(color: Colors.black, fontSize: 13.sp)),
                  SizedBox(height: 0.5.h),
                  TextFormField(
                    controller: transactionCustomerViewModel.newCustomerInstagramText,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(1.h), borderSide: BorderSide.none),
                      contentPadding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                      fillColor: AppColor.disabledBackground,
                      filled: true,
                      hintStyle: TextStyle(color: AppColor.disabled, fontSize: 12.sp),
                      hintText: "Customer's Instagram Account",
                    ),
                    style: TextStyle(color: Colors.black, fontSize: 12.sp, fontWeight: FontWeight.bold),
                    textInputAction: TextInputAction.done,
                  ),
                  SizedBox(height: 2.h),
                  Text("Customer's Email", style: TextStyle(color: Colors.black, fontSize: 13.sp)),
                  SizedBox(height: 0.5.h),
                  TextFormField(
                    controller: transactionCustomerViewModel.newCustomerEmailText,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(1.h), borderSide: BorderSide.none),
                      contentPadding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                      fillColor: AppColor.disabledBackground,
                      filled: true,
                      hintStyle: TextStyle(color: AppColor.disabled, fontSize: 12.sp),
                      hintText: "Customer's Email",
                    ),
                    onChanged: (_) => _newCustomerFormKey.currentState!.validate(),
                    style: TextStyle(color: Colors.black, fontSize: 12.sp, fontWeight: FontWeight.bold),
                    textInputAction: TextInputAction.done,
                    validator: (str) => transactionCustomerViewModel.validateEmail(),
                  ),
                  SizedBox(height: 2.h),
                  Text("Customer's Phone Number", style: TextStyle(color: Colors.black, fontSize: 13.sp)),
                  SizedBox(height: 0.5.h),
                  TextFormField(
                    controller: transactionCustomerViewModel.newCustomerPhoneText,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(1.h), borderSide: BorderSide.none),
                      contentPadding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                      fillColor: AppColor.disabledBackground,
                      filled: true,
                      hintStyle: TextStyle(color: AppColor.disabled, fontSize: 12.sp),
                      hintText: "Customer's Phone Number",
                    ),
                    onChanged: (_) => _newCustomerFormKey.currentState!.validate(),
                    style: TextStyle(color: Colors.black, fontSize: 12.sp, fontWeight: FontWeight.bold),
                    textInputAction: TextInputAction.done,
                    validator: (str) => transactionCustomerViewModel.validatePhone(),
                  ),
                  SizedBox(height: 2.h),
                  Expanded(child: Container()),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: LoadingButton(
                      textButton: TextButton(
                        onPressed: () async {
                          if (transactionCustomerViewModel.isLoadingAddCustomer) return;

                          transactionCustomerViewModel.startValidation();
                          if (_newCustomerFormKey.currentState!.validate()) {
                            await transactionCustomerViewModel.addCustomer();
                          }
                        },
                        child: Text(
                          "DONE",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: AppColor.primary,
                          padding: EdgeInsets.symmetric(horizontal: 0.5.w, vertical: 0.5.h),
                          primary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(1.h),
                            side: BorderSide(color: AppColor.primary),
                          ),
                          shadowColor: Color.fromARGB(255, 208, 239, 230),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
