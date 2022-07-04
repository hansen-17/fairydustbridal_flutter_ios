import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

import '../../../../../utils/app_color.dart';
import '../../../../../utils/size_util.dart';
import 'search_product_card.dart';
import 'search_product_viewmodel.dart';

class SearchProductScreen extends StatelessWidget {
  final SearchProductViewModel searchProductViewModel = Get.put(SearchProductViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Search Product",
          style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold),
          maxLines: 1,
          softWrap: false,
          overflow: TextOverflow.fade,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(
          left: 5.w,
          top: 3.h,
          right: 5.w,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 1.w),
              child: Text("Search by code :", style: TextStyle(color: Colors.black, fontSize: 12.sp)),
            ),
            SizedBox(height: 1.h),
            TextFormField(
              controller: searchProductViewModel.productNameText,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(1.h), borderSide: BorderSide.none),
                contentPadding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                fillColor: AppColor.disabledBackground,
                filled: true,
                hintStyle: TextStyle(color: AppColor.disabled, fontSize: 12.sp),
                hintText: "Product Code",
                suffixIcon: IconButton(
                  onPressed: () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    await Future.delayed(Duration(milliseconds: 500));
                    FocusManager.instance.primaryFocus?.unfocus();
                    await Future.delayed(Duration(seconds: 1));
                    Get.toNamed("/scan-qr");
                  },
                  icon: Icon(Icons.search),
                ),
              ),
              onChanged: (_) {
                if (searchProductViewModel.debounce?.isActive ?? false) searchProductViewModel.debounce!.cancel();
                searchProductViewModel.debounce = Timer(const Duration(milliseconds: 500), () {
                  searchProductViewModel.getProducts();
                });
              },
              style: TextStyle(color: Colors.black, fontSize: 12.sp, fontWeight: FontWeight.bold),
              textInputAction: TextInputAction.done,
            ),
            SizedBox(height: 2.h),
            Expanded(
              child: GetBuilder<SearchProductViewModel>(
                builder: (_) {
                  if (searchProductViewModel.isLoadingProducts) return Center(child: Container(width: 5.w, height: 5.w, child: CircularProgressIndicator()));

                  return LazyLoadScrollView(
                    onEndOfPage: () => searchProductViewModel.loadMoreProducts(),
                    child: ListView.separated(
                      itemBuilder: (context, index) {
                        if (searchProductViewModel.products[index].id == "") return Center(child: Container(width: 5.w, height: 5.w, child: CircularProgressIndicator()));

                        return SearchProductCard(product: searchProductViewModel.products[index]);
                      },
                      separatorBuilder: (context, index) => SizedBox(height: 1.h),
                      itemCount: searchProductViewModel.products.length,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
