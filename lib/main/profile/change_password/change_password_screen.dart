import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/app_color.dart';
import '../../../utils/loading_button.dart';
import '../../../utils/size_util.dart';
import 'change_password_viewmodel.dart';

class ChangePasswordScreen extends StatelessWidget {
  final ChangePasswordViewModel changePasswordViewModel = Get.put(ChangePasswordViewModel());
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Change Password",
            style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold),
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.fade,
          ),
        ),
        body: SingleChildScrollView(
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
                        child: Text("Current Password", style: TextStyle(color: Colors.black, fontSize: 12.sp)),
                      ),
                      SizedBox(height: 1.h),
                      GetBuilder<ChangePasswordViewModel>(
                        builder: (_) {
                          return TextFormField(
                            controller: changePasswordViewModel.currentPasswordText,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(1.h), borderSide: BorderSide.none),
                              contentPadding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                              fillColor: AppColor.disabledBackground,
                              filled: true,
                              hintStyle: TextStyle(color: AppColor.disabled),
                              hintText: "Current Password",
                              prefixIcon: Icon(Icons.lock),
                            ),
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: true,
                            onChanged: (_) => _loginFormKey.currentState!.validate(),
                            style: TextStyle(color: Colors.black, fontSize: 14.sp, fontWeight: FontWeight.bold),
                            textInputAction: TextInputAction.done,
                            validator: (_) => changePasswordViewModel.validateCurrentPassword(),
                          );
                        },
                      ),
                      SizedBox(height: 3.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 1.w),
                        child: Text("New Password", style: TextStyle(color: Colors.black, fontSize: 12.sp)),
                      ),
                      SizedBox(height: 1.h),
                      GetBuilder<ChangePasswordViewModel>(
                        builder: (_) {
                          return TextFormField(
                            controller: changePasswordViewModel.newPasswordText,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(1.h), borderSide: BorderSide.none),
                              contentPadding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                              fillColor: AppColor.disabledBackground,
                              filled: true,
                              hintStyle: TextStyle(color: AppColor.disabled),
                              hintText: "New Password",
                              prefixIcon: Icon(Icons.lock),
                            ),
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: true,
                            onChanged: (_) => _loginFormKey.currentState!.validate(),
                            style: TextStyle(color: Colors.black, fontSize: 14.sp, fontWeight: FontWeight.bold),
                            textInputAction: TextInputAction.done,
                            validator: (_) => changePasswordViewModel.validateNewPassword(),
                          );
                        },
                      ),
                      SizedBox(height: 3.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 1.w),
                        child: Text("Confirm New Password", style: TextStyle(color: Colors.black, fontSize: 12.sp)),
                      ),
                      SizedBox(height: 1.h),
                      GetBuilder<ChangePasswordViewModel>(
                        builder: (_) {
                          return TextFormField(
                            controller: changePasswordViewModel.confirmNewPasswordText,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(1.h), borderSide: BorderSide.none),
                              contentPadding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                              fillColor: AppColor.disabledBackground,
                              filled: true,
                              hintStyle: TextStyle(color: AppColor.disabled),
                              hintText: "Confirm New Password",
                              prefixIcon: Icon(Icons.lock),
                            ),
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: true,
                            onChanged: (_) => _loginFormKey.currentState!.validate(),
                            style: TextStyle(color: Colors.black, fontSize: 14.sp, fontWeight: FontWeight.bold),
                            textInputAction: TextInputAction.done,
                            validator: (_) => changePasswordViewModel.validateConfirmNewPassword(),
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
                                if (changePasswordViewModel.isLoading) return;

                                changePasswordViewModel.startValidation();
                                if (_loginFormKey.currentState!.validate()) {
                                  await changePasswordViewModel.changePassword();
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
        ),
      ),
    );
  }
}
