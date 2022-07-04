import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../utils/app_color.dart';
import '../../../../../utils/loading_button.dart';
import '../../../../../utils/size_util.dart';
import '../../../../utils/custom_dropdown.dart';
import 'add_package_viewmodel.dart';

class AddPackageScreen extends StatelessWidget {
  final AddPackageViewModel addPackageViewModel = Get.put(AddPackageViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          addPackageViewModel.isEdit ? "Edit Package" : "Add Package",
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
                padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 3.h, bottom: 15.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Package Name",
                      style: TextStyle(color: Colors.black, fontSize: 16.sp, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 1.5.h),
                    TextFormField(
                      controller: addPackageViewModel.packageNameText,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(1.h), borderSide: BorderSide.none),
                        contentPadding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                        fillColor: AppColor.disabledBackground,
                        filled: true,
                        hintStyle: TextStyle(color: AppColor.disabled, fontSize: 12.sp),
                        hintText: "Package's Name",
                      ),
                      style: TextStyle(color: Colors.black, fontSize: 12.sp, fontWeight: FontWeight.bold),
                      textInputAction: TextInputAction.done,
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      "Price",
                      style: TextStyle(color: Colors.black, fontSize: 16.sp, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 1.5.h),
                    TextFormField(
                      controller: addPackageViewModel.priceText,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(1.h), borderSide: BorderSide.none),
                        contentPadding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                        fillColor: AppColor.disabledBackground,
                        filled: true,
                        hintStyle: TextStyle(color: AppColor.disabled, fontSize: 12.sp),
                        hintText: "Package's Price",
                        prefixText: "Rp",
                        prefixStyle: TextStyle(color: Colors.black, fontSize: 12.sp),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        _ThousandsSeparatorInputFormatter(),
                      ],
                      style: TextStyle(color: Colors.black, fontSize: 12.sp, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.end,
                      textInputAction: TextInputAction.done,
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      "Package's Photo",
                      style: TextStyle(color: Colors.black, fontSize: 16.sp, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 1.5.h),
                    GetBuilder<AddPackageViewModel>(
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
                            if (addPackageViewModel.imageFile == null) {
                              return GestureDetector(
                                onTap: () async => await addPackageViewModel.pickMultiImage(),
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
                                      File(addPackageViewModel.imageFile!.path),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 0.5.h,
                                  right: 0.5.h,
                                  child: GestureDetector(
                                    onTap: () {
                                      addPackageViewModel.removeImageFile();
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
                          itemCount: 1,
                        );
                      },
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      "List of Product(s)",
                      style: TextStyle(color: Colors.black, fontSize: 16.sp, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 1.5.h),
                    GetBuilder<AddPackageViewModel>(
                      builder: (_) {
                        return ListView.separated(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            if (index == addPackageViewModel.packageDetailProducts.length) {
                              return Row(
                                children: [
                                  Container(
                                    width: 5.w,
                                    child: Text(
                                      "${index + 1}.",
                                      style: TextStyle(color: Colors.black, fontSize: 14.sp, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(width: 1.w),
                                  Expanded(
                                    child: TextButton(
                                      onPressed: () {
                                        addPackageViewModel.addNewPackageDetailProducts();
                                      },
                                      child: Text(
                                        "Add Product",
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
                                  SizedBox(width: 8.w),
                                  Spacer(),
                                ],
                              );
                            }

                            return Row(
                              children: [
                                Container(
                                  width: 5.w,
                                  child: Text(
                                    "${index + 1}.",
                                    style: TextStyle(color: Colors.black, fontSize: 14.sp, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(width: 1.w),
                                Expanded(
                                    child: addPackageViewModel.productTypeItems.isEmpty
                                        ? Container()
                                        : CustomDropdown<dynamic>(
                                            child: Container(
                                              padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.h),
                                              child: Text(
                                                addPackageViewModel.packageDetailProducts[index].type.name,
                                                style: addPackageViewModel.selectButtonTextStyle,
                                                maxLines: 1,
                                                overflow: TextOverflow.fade,
                                                softWrap: false,
                                              ),
                                            ),
                                            onChange: (dynamic value, int i) => addPackageViewModel.setProductType(value, index),
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
                                            items: addPackageViewModel.productTypeItems,
                                          )),
                                SizedBox(width: 2.w),
                                Expanded(
                                  child: addPackageViewModel.productCategoryItems.isEmpty
                                      ? Container()
                                      : CustomDropdown<dynamic>(
                                          child: Container(
                                            padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.h),
                                            child: Text(
                                              addPackageViewModel.packageDetailProducts[index].category.name,
                                              style: addPackageViewModel.selectButtonTextStyle,
                                              maxLines: 1,
                                              overflow: TextOverflow.fade,
                                              softWrap: false,
                                            ),
                                          ),
                                          onChange: (dynamic value, int i) => addPackageViewModel.setProductCategory(value, index),
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
                                          items: addPackageViewModel.productCategoryItems,
                                        ),
                                ),
                                SizedBox(width: 1.w),
                                GestureDetector(
                                  onTap: () => addPackageViewModel.removePackageDetailProducts(index),
                                  child: Icon(Icons.delete, color: AppColor.primary, size: 5.w),
                                ),
                              ],
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) => SizedBox(height: 0.5.h),
                          itemCount: addPackageViewModel.packageDetailProducts.length + 1,
                        );
                      },
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      "List of Service(s)",
                      style: TextStyle(color: Colors.black, fontSize: 16.sp, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 1.5.h),
                    GetBuilder<AddPackageViewModel>(
                      builder: (_) {
                        return ListView.separated(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            if (index == addPackageViewModel.packageDetailServices.length) {
                              return Row(
                                children: [
                                  Container(
                                    width: 5.w,
                                    child: Text(
                                      "${index + 1}.",
                                      style: TextStyle(color: Colors.black, fontSize: 14.sp, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(width: 1.w),
                                  Expanded(
                                    child: TextButton(
                                      onPressed: () {
                                        addPackageViewModel.addNewPackageDetailServices();
                                      },
                                      child: Text(
                                        "Add Service",
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
                                  SizedBox(width: 8.w),
                                  Spacer(),
                                ],
                              );
                            }

                            return Row(
                              children: [
                                Container(
                                  width: 5.w,
                                  child: Text(
                                    "${index + 1}.",
                                    style: TextStyle(color: Colors.black, fontSize: 14.sp, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(width: 1.w),
                                Expanded(
                                    child: addPackageViewModel.services.isEmpty
                                        ? Container()
                                        : CustomDropdown<dynamic>(
                                            child: Container(
                                              padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.h),
                                              child: Text(
                                                addPackageViewModel.packageDetailServices[index].service.description,
                                                style: addPackageViewModel.selectButtonTextStyle,
                                                maxLines: 1,
                                                overflow: TextOverflow.fade,
                                                softWrap: false,
                                              ),
                                            ),
                                            onChange: (dynamic value, int i) => addPackageViewModel.setService(value, index),
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
                                            items: addPackageViewModel.serviceItems,
                                          )),
                                SizedBox(width: 1.w),
                                GestureDetector(
                                  onTap: () => addPackageViewModel.removePackageDetailServices(index),
                                  child: Icon(Icons.delete, color: AppColor.primary, size: 5.w),
                                ),
                                SizedBox(width: 2.w),
                                Spacer(),
                              ],
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) => SizedBox(height: 0.5.h),
                          itemCount: addPackageViewModel.packageDetailServices.length + 1,
                        );
                      },
                    ),
                  ],
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
                        await addPackageViewModel.savePackage();
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

class _ThousandsSeparatorInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length == 0) {
      return newValue.copyWith(text: "0");
    }

    String newValueText = newValue.text.replaceAll(".", "").replaceAll(",", "");

    if (oldValue.text.endsWith(".") && oldValue.text.length == newValue.text.length + 1) {
      newValueText = newValueText.substring(0, newValueText.length - 1);
    }

    int selectionIndex = newValue.text.length - newValue.selection.extentOffset;

    String? newString = "0";
    if (double.tryParse(newValueText) != null) newString = NumberFormat("#,###").format(double.parse(newValueText));

    return TextEditingValue(
      text: newString.replaceAll(",", "."),
      selection: TextSelection.collapsed(
        offset: newString.length - selectionIndex,
      ),
    );
  }
}
