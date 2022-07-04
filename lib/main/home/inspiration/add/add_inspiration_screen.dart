import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../utils/app_color.dart';
import '../../../../../utils/loading_button.dart';
import '../../../../../utils/size_util.dart';
import 'add_inspiration_viewmodel.dart';

class AddInspirationScreen extends StatelessWidget {
  final AddInspirationViewModel addInspirationViewModel = Get.put(AddInspirationViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          addInspirationViewModel.isEdit ? "Edit Gallery Folder" : "Add Gallery Folder",
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
                        "Folder Name",
                        style: TextStyle(color: Colors.black, fontSize: 16.sp, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 1.5.h),
                      TextFormField(
                        controller: addInspirationViewModel.folderNameText,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(1.h), borderSide: BorderSide.none),
                          contentPadding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                          fillColor: AppColor.disabledBackground,
                          filled: true,
                          hintStyle: TextStyle(color: AppColor.disabled, fontSize: 12.sp),
                          hintText: "Folder's Name",
                        ),
                        style: TextStyle(color: Colors.black, fontSize: 12.sp, fontWeight: FontWeight.bold),
                        textInputAction: TextInputAction.done,
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        "Photo(s)",
                        style: TextStyle(color: Colors.black, fontSize: 16.sp, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 1.5.h),
                      GetBuilder<AddInspirationViewModel>(
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
                              if (index == addInspirationViewModel.imageFileList.length) {
                                return GestureDetector(
                                  onTap: () async => await addInspirationViewModel.pickMultiImage(),
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
                                        File(addInspirationViewModel.imageFileList[index].path),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 0.5.h,
                                    right: 0.5.h,
                                    child: GestureDetector(
                                      onTap: () {
                                        addInspirationViewModel.removeImageFile(index);
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
                            itemCount: addInspirationViewModel.imageFileList.length + 1,
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
                        await addInspirationViewModel.saveInspiration();
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
