import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '/../../utils/size_util.dart';
import '../../../../../utils/app_color.dart';
import 'product_detail_viewmodel.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductDetailViewModel productDetailViewModel = Get.put(ProductDetailViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          productDetailViewModel.product.code,
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
                  image: Image.asset("assets/images/home-background.jpg").image,
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.white.withOpacity(0.95),
                    BlendMode.luminosity,
                  ),
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Product Type",
                        style: TextStyle(color: Colors.black, fontSize: 16.sp, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 1.5.h),
                      TextFormField(
                        controller: TextEditingController(text: productDetailViewModel.product.type.name),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(1.h), borderSide: BorderSide.none),
                          contentPadding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                          fillColor: AppColor.disabledBackground,
                          filled: true,
                          hintStyle: TextStyle(color: AppColor.disabled, fontSize: 12.sp),
                          hintText: "Product Type",
                          prefixIcon: Icon(Icons.shopping_bag),
                        ),
                        readOnly: true,
                        style: TextStyle(color: Colors.black, fontSize: 12.sp, fontWeight: FontWeight.bold),
                        textInputAction: TextInputAction.next,
                        validator: (str) {},
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        "Product Category",
                        style: TextStyle(color: Colors.black, fontSize: 16.sp, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 1.5.h),
                      TextFormField(
                        controller: TextEditingController(text: productDetailViewModel.product.category.name),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(1.h), borderSide: BorderSide.none),
                          contentPadding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                          fillColor: AppColor.disabledBackground,
                          filled: true,
                          hintStyle: TextStyle(color: AppColor.disabled, fontSize: 12.sp),
                          hintText: "Product Category",
                          prefixIcon: Icon(Icons.category),
                        ),
                        readOnly: true,
                        style: TextStyle(color: Colors.black, fontSize: 12.sp, fontWeight: FontWeight.bold),
                        textInputAction: TextInputAction.next,
                        validator: (str) {},
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        "Product's Photo(s)",
                        style: TextStyle(color: Colors.black, fontSize: 16.sp, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 1.5.h),
                      GridView.builder(
                        primary: true,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 1,
                          crossAxisCount: 3,
                          crossAxisSpacing: 2.w,
                          mainAxisSpacing: 2.w,
                        ),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () => Get.toNamed("/product-photo", arguments: productDetailViewModel.product.photos[index].photoUrl),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(1.h),
                              child: Image.network(
                                productDetailViewModel.product.photos[index].photoUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                        itemCount: productDetailViewModel.product.photos.length,
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        "Product's Rent Schedule",
                        style: TextStyle(color: Colors.black, fontSize: 16.sp, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 1.h),
                      GetBuilder<ProductDetailViewModel>(
                        builder: (_) {
                          if (productDetailViewModel.isLoadingInfo) return Center(child: Container(margin: EdgeInsets.only(top: 5.h), width: 5.w, height: 5.w, child: CircularProgressIndicator()));

                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                            child: SfDateRangePicker(
                              allowViewNavigation: false,
                              headerStyle: DateRangePickerHeaderStyle(
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  fontFamily: "ProximaNova",
                                ),
                              ),
                              monthViewSettings: DateRangePickerMonthViewSettings(blackoutDates: productDetailViewModel.blackOutDates, weekendDays: [7]),
                              monthCellStyle: DateRangePickerMonthCellStyle(
                                blackoutDateTextStyle: TextStyle(color: Colors.white),
                                blackoutDatesDecoration: BoxDecoration(color: AppColor.disabled, shape: BoxShape.circle),
                                textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                weekendTextStyle: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                              ),
                              selectionMode: DateRangePickerSelectionMode.single,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
