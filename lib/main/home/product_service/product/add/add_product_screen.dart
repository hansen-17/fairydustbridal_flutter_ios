import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../utils/app_color.dart';
import '../../../../../utils/custom_dropdown.dart';
import '../../../../../utils/loading_button.dart';
import '../../../../../utils/size_util.dart';
import 'add_product_viewmodel.dart';

class AddProductScreen extends StatelessWidget {
  final AddProductViewModel addProductViewModel = Get.put(AddProductViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          addProductViewModel.isEdit ? "Edit Product" : "Add Product",
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
                      GetBuilder<AddProductViewModel>(
                        builder: (_) {
                          return CustomDropdown<dynamic>(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.h),
                              child: Text(
                                addProductViewModel.selectedType?.name ?? "",
                                style: addProductViewModel.selectButtonTextStyle,
                                maxLines: 1,
                                overflow: TextOverflow.fade,
                                softWrap: false,
                              ),
                            ),
                            onChange: (dynamic value, int index) => addProductViewModel.setProductType(value),
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
                            items: addProductViewModel.productTypeItems,
                          );
                        },
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        "Product Category",
                        style: TextStyle(color: Colors.black, fontSize: 16.sp, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 1.5.h),
                      GetBuilder<AddProductViewModel>(
                        builder: (_) {
                          return CustomDropdown<dynamic>(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.h),
                              child: Text(
                                addProductViewModel.selectedCategory?.name ?? "",
                                style: addProductViewModel.selectButtonTextStyle,
                                maxLines: 1,
                                overflow: TextOverflow.fade,
                                softWrap: false,
                              ),
                            ),
                            onChange: (dynamic value, int index) => addProductViewModel.setProductCategory(value),
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
                            items: addProductViewModel.productCategoryItems,
                          );
                        },
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        "Product's Photo(s)",
                        style: TextStyle(color: Colors.black, fontSize: 16.sp, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 1.5.h),
                      GetBuilder<AddProductViewModel>(
                        builder: (_) {
                          return GridView.builder(
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
                              if (index == addProductViewModel.imageFileList.length) {
                                return GestureDetector(
                                  onTap: () async => await addProductViewModel.pickMultiImage(),
                                  child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(1.h),
                                        color: AppColor.primary,
                                      ),
                                      child: Icon(Icons.add, color: Colors.white, size: 5.h)),
                                );
                              }

                              return Stack(
                                children: [
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    left: 0,
                                    bottom: 0,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(1.h),
                                      child: Image.file(
                                        File(addProductViewModel.imageFileList[index].path),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 0.5.h,
                                    right: 0.5.h,
                                    child: GestureDetector(
                                      onTap: () {
                                        addProductViewModel.removeImageFile(index);
                                      },
                                      child: Icon(
                                        Icons.remove_circle,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                            itemCount: addProductViewModel.imageFileList.length + 1,
                          );
                        },
                      ),
                      SizedBox(height: 3.h),
                    ],
                  ),
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
                Container(
                  width: 100.w,
                  child: LoadingButton(
                    textButton: TextButton(
                      onPressed: () async {
                        await addProductViewModel.saveProduct();
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
    );
  }
}
