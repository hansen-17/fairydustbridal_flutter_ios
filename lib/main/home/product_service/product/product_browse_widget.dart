import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

import '../../../../utils/app_color.dart';
import '../../../../utils/custom_dropdown.dart';
import '../../../../utils/global_controller.dart';
import '../../../../utils/size_util.dart';
import 'product_browse_viewmodel.dart';
import 'product_card.dart';

class ProductBrowseWidget extends StatelessWidget {
  final ProductBrowseViewModel productBrowseViewModel = Get.put(ProductBrowseViewModel());

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 1.w),
                  child: Text("Product Type : ", style: productBrowseViewModel.selectButtonTextStyle),
                ),
              ),
              SizedBox(width: 5.w),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 1.w),
                  child: Text("Product Category : ", style: productBrowseViewModel.selectButtonTextStyle),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: GetBuilder<ProductBrowseViewModel>(
                  builder: (_) {
                    return productBrowseViewModel.productTypeItems.isEmpty
                        ? Container()
                        : CustomDropdown<dynamic>(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.h),
                              child: Text(
                                productBrowseViewModel.selectedType.name,
                                style: productBrowseViewModel.selectButtonTextStyle,
                                maxLines: 1,
                                overflow: TextOverflow.fade,
                                softWrap: false,
                              ),
                            ),
                            onChange: (dynamic value, int index) => productBrowseViewModel.setProductType(value),
                            dropdownButtonStyle: DropdownButtonStyle(
                              elevation: 0.5.h,
                              backgroundColor: Colors.white,
                              primaryColor: AppColor.primary,
                            ),
                            dropdownStyle: DropdownStyle(
                              borderRadius: BorderRadius.circular(1.h),
                              elevation: 0.5.h,
                              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                            ),
                            items: productBrowseViewModel.productTypeItems,
                          );
                  },
                ),
              ),
              SizedBox(width: 5.w),
              Expanded(
                child: GetBuilder<ProductBrowseViewModel>(
                  builder: (_) {
                    return productBrowseViewModel.productCategoryItems.isEmpty
                        ? Container()
                        : CustomDropdown<dynamic>(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.h),
                              child: Text(
                                productBrowseViewModel.selectedCategory.name,
                                style: productBrowseViewModel.selectButtonTextStyle,
                                maxLines: 1,
                                overflow: TextOverflow.fade,
                                softWrap: false,
                              ),
                            ),
                            onChange: (dynamic value, int index) => productBrowseViewModel.setProductCategory(value),
                            dropdownButtonStyle: DropdownButtonStyle(
                              elevation: 0.5.h,
                              backgroundColor: Colors.white,
                              primaryColor: AppColor.primary,
                            ),
                            dropdownStyle: DropdownStyle(
                              borderRadius: BorderRadius.circular(1.h),
                              elevation: 0.5.h,
                              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                            ),
                            items: productBrowseViewModel.productCategoryItems,
                          );
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Expanded(
            child: GetBuilder<ProductBrowseViewModel>(
              builder: (_) {                
                if (productBrowseViewModel.isLoading) return Center(child: Container(width: 5.w, height: 5.w, child: CircularProgressIndicator()));

                return LazyLoadScrollView(
                  onEndOfPage: () => productBrowseViewModel.loadMoreProduct(),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: GlobalController.instance.isPhone ? 0.8 : 0.75,
                      crossAxisCount: GlobalController.instance.isPhone ? 2 : 3,
                      crossAxisSpacing: 5.w,
                      mainAxisSpacing: 1.h,
                    ),
                    itemBuilder: (context, index) {
                      if (productBrowseViewModel.products[index].id == "") return Center(child: Container(width: 5.w, height: 5.w, child: CircularProgressIndicator()));

                      return ProductCard(product: productBrowseViewModel.products[index], clickable: true);
                    },
                    itemCount: productBrowseViewModel.products.length,
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
