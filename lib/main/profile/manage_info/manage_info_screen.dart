import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/app_color.dart';
import '../../../utils/loading_button.dart';
import '../../../utils/size_util.dart';
import 'manage_info_viewmodel.dart';

class ManageInfoScreen extends StatelessWidget {
  final ManageInfoViewModel manageInfoViewModel = Get.put(ManageInfoViewModel());
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Manage Information",
            style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold),
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.fade,
          ),
        ),
        body: GetBuilder<ManageInfoViewModel>(
          builder: (_) {
            print(manageInfoViewModel.isLoadingInit);
            if (manageInfoViewModel.isLoadingInit) return Center(child: Container(width: 5.w, height: 5.w, child: CircularProgressIndicator()));
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: 100.w,
                    height: 100.h - 56,
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(7.w), topRight: Radius.circular(7.w)),
                      color: Colors.white,
                    ),
                    child: Form(
                      key: _loginFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 1.w),
                            child: Text("Description", style: TextStyle(color: Colors.black, fontSize: 12.sp)),
                          ),
                          SizedBox(height: 1.h),
                          GetBuilder<ManageInfoViewModel>(
                            builder: (_) {
                              return TextFormField(
                                controller: manageInfoViewModel.descriptionText,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(1.h), borderSide: BorderSide.none),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                                  fillColor: AppColor.disabledBackground,
                                  filled: true,
                                  hintStyle: TextStyle(color: AppColor.disabled),
                                  hintText: "Description",
                                ),
                                keyboardType: TextInputType.visiblePassword,
                                maxLines: 5,
                                minLines: 3,
                                onChanged: (_) => _loginFormKey.currentState!.validate(),
                                style: TextStyle(color: Colors.black, fontSize: 14.sp, fontWeight: FontWeight.bold),
                                textInputAction: TextInputAction.done,
                                validator: (_) => manageInfoViewModel.validateDescription(),
                              );
                            },
                          ),
                          SizedBox(height: 3.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 1.w),
                            child: Text("Whatsapp", style: TextStyle(color: Colors.black, fontSize: 12.sp)),
                          ),
                          SizedBox(height: 1.h),
                          GetBuilder<ManageInfoViewModel>(
                            builder: (_) {
                              return TextFormField(
                                controller: manageInfoViewModel.whatsappText,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(1.h), borderSide: BorderSide.none),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                                  fillColor: AppColor.disabledBackground,
                                  filled: true,
                                  hintStyle: TextStyle(color: AppColor.disabled),
                                  hintText: "Whatsapp",
                                ),
                                keyboardType: TextInputType.visiblePassword,
                                onChanged: (_) => _loginFormKey.currentState!.validate(),
                                style: TextStyle(color: Colors.black, fontSize: 14.sp, fontWeight: FontWeight.bold),
                                textInputAction: TextInputAction.done,
                                validator: (_) => manageInfoViewModel.validateWhatsapp(),
                              );
                            },
                          ),
                          SizedBox(height: 3.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 1.w),
                            child: Text("Facebook", style: TextStyle(color: Colors.black, fontSize: 12.sp)),
                          ),
                          SizedBox(height: 1.h),
                          GetBuilder<ManageInfoViewModel>(
                            builder: (_) {
                              return TextFormField(
                                controller: manageInfoViewModel.facebookText,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(1.h), borderSide: BorderSide.none),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                                  fillColor: AppColor.disabledBackground,
                                  filled: true,
                                  hintStyle: TextStyle(color: AppColor.disabled),
                                  hintText: "Facebook",
                                ),
                                keyboardType: TextInputType.visiblePassword,
                                onChanged: (_) => _loginFormKey.currentState!.validate(),
                                style: TextStyle(color: Colors.black, fontSize: 14.sp, fontWeight: FontWeight.bold),
                                textInputAction: TextInputAction.done,
                                validator: (_) => manageInfoViewModel.validateFacebook(),
                              );
                            },
                          ),
                          SizedBox(height: 3.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 1.w),
                            child: Text("Instagram", style: TextStyle(color: Colors.black, fontSize: 12.sp)),
                          ),
                          SizedBox(height: 1.h),
                          GetBuilder<ManageInfoViewModel>(
                            builder: (_) {
                              return TextFormField(
                                controller: manageInfoViewModel.instagramText,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(1.h), borderSide: BorderSide.none),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                                  fillColor: AppColor.disabledBackground,
                                  filled: true,
                                  hintStyle: TextStyle(color: AppColor.disabled),
                                  hintText: "Instagram",
                                ),
                                keyboardType: TextInputType.visiblePassword,
                                onChanged: (_) => _loginFormKey.currentState!.validate(),
                                style: TextStyle(color: Colors.black, fontSize: 14.sp, fontWeight: FontWeight.bold),
                                textInputAction: TextInputAction.done,
                                validator: (_) => manageInfoViewModel.validateInstagram(),
                              );
                            },
                          ),
                          SizedBox(height: 3.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 1.w),
                            child: Text("Footer", style: TextStyle(color: Colors.black, fontSize: 12.sp)),
                          ),
                          SizedBox(height: 1.h),
                          GetBuilder<ManageInfoViewModel>(
                            builder: (_) {
                              return TextFormField(
                                controller: manageInfoViewModel.headerText,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(1.h), borderSide: BorderSide.none),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                                  fillColor: AppColor.disabledBackground,
                                  filled: true,
                                  hintStyle: TextStyle(color: AppColor.disabled),
                                  hintText: "Footer",
                                ),
                                keyboardType: TextInputType.visiblePassword,
                                maxLines: 3,
                                minLines: 2,
                                onChanged: (_) => _loginFormKey.currentState!.validate(),
                                style: TextStyle(color: Colors.black, fontSize: 14.sp, fontWeight: FontWeight.bold),
                                textInputAction: TextInputAction.done,
                                validator: (_) => manageInfoViewModel.validateHeader(),
                              );
                            },
                          ),
                          Expanded(child: Container()),
                          Center(
                            child: SizedBox(
                              width: 100.w,
                              child: LoadingButton(
                                textButton: TextButton(
                                  onPressed: () async {
                                    if (manageInfoViewModel.isLoadingSave) return;

                                    manageInfoViewModel.startValidation();
                                    if (_loginFormKey.currentState!.validate()) {
                                      await manageInfoViewModel.updateAbout();
                                    }
                                  },
                                  child: Text(
                                    "Save",
                                    style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold),
                                  ),
                                  style: TextButton.styleFrom(
                                    backgroundColor: AppColor.primary,
                                    elevation: 0.35.h,
                                    padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.5.h),
                                    primary: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1.h)),
                                    shadowColor: Color.fromARGB(255, 208, 239, 230),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
