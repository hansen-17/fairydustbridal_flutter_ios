import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

import '../../../../utils/app_color.dart';
import '../../../../utils/size_util.dart';
import 'transaction_package_card.dart';
import 'transaction_package_viewmodel.dart';

class TransactionPackageBottomSheet extends StatelessWidget {
  final TransactionPackageViewModel transactionPackageViewModel = Get.put(TransactionPackageViewModel());

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 1.w),
            child: Text("Search by name :", style: TextStyle(color: Colors.black, fontSize: 12.sp)),
          ),
          SizedBox(height: 1.h),
          TextFormField(
            controller: transactionPackageViewModel.packageNameText,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(1.h), borderSide: BorderSide.none),
              contentPadding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              fillColor: AppColor.disabledBackground,
              filled: true,
              hintStyle: TextStyle(color: AppColor.disabled, fontSize: 12.sp),
              hintText: "Package Name",
            ),
            onChanged: (_) {
              if (transactionPackageViewModel.debounce?.isActive ?? false) transactionPackageViewModel.debounce!.cancel();
              transactionPackageViewModel.debounce = Timer(const Duration(milliseconds: 500), () {
                transactionPackageViewModel.getPackages();
              });
            },
            style: TextStyle(color: Colors.black, fontSize: 12.sp, fontWeight: FontWeight.bold),
            textInputAction: TextInputAction.done,
          ),
          SizedBox(height: 2.h),
          Expanded(
            child: GetBuilder<TransactionPackageViewModel>(
              builder: (_) {
                if (transactionPackageViewModel.isLoading) return Center(child: Container(width: 5.w, height: 5.w, child: CircularProgressIndicator()));

                return LazyLoadScrollView(
                  onEndOfPage: () => transactionPackageViewModel.loadMorePackages(),
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      if (transactionPackageViewModel.packages[index].id == "") return Center(child: Container(width: 5.w, height: 5.w, child: CircularProgressIndicator()));

                      return TransactionPackageCard(package: transactionPackageViewModel.packages[index]);
                    },
                    separatorBuilder: (context, index) => SizedBox(height: 1.h),
                    itemCount: transactionPackageViewModel.packages.length,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
