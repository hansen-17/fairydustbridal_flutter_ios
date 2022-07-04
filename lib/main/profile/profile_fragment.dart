import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/app_color.dart';
import '../../utils/size_util.dart';
import 'profile_header.dart';
import 'profile_viewmodel.dart';

class ProfileFragment extends StatelessWidget {
  final ProfileViewModel profileViewModel = Get.put(ProfileViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(
          left: 5.w,
          top: SizeUtil.statusBarHeight() + 3.h,
          right: 5.w,
          bottom: 3.h,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileHeader(),
              SizedBox(height: 5.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Row(
                  children: [
                    Container(
                      child: Icon(Icons.manage_accounts, color: Colors.white),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(1.h), color: AppColor.primary),
                      padding: EdgeInsets.all(1.h),
                    ),
                    SizedBox(width: 5.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Account Settings", style: TextStyle(color: Colors.black, fontSize: 18.sp, fontWeight: FontWeight.bold)),
                          Text(
                            "Edit and manage your account details",
                            style: TextStyle(color: AppColor.disabled, fontSize: 12.sp, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 3.h),
              Container(
                width: 100.w,
                margin: EdgeInsets.symmetric(horizontal: 5.w),
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1.5.h),
                  color: AppColor.disabledBackground,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => Get.toNamed("/change-password"),
                      child: Container(
                        color: Colors.transparent,
                        padding: EdgeInsets.symmetric(vertical: 0.5.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Change Password", style: TextStyle(color: Colors.black, fontSize: 16.sp, fontWeight: FontWeight.bold)),
                            Icon(Icons.keyboard_arrow_right, size: 5.w),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 0.5.h),
                      child: Divider(thickness: 0.1.h),
                    ),
                    GestureDetector(
                      onTap: () async => profileViewModel.deactivateAccount(),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 0.5.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Deactivate Account", style: TextStyle(color: Colors.black, fontSize: 16.sp, fontWeight: FontWeight.bold)),
                            GetBuilder<ProfileViewModel>(
                              builder: (_) => profileViewModel.isLoadingDeactivate ? Container(width: 5.w, height: 5.w, child: CircularProgressIndicator()) : Icon(Icons.keyboard_arrow_right, size: 5.w),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Row(
                  children: [
                    Container(
                      child: Icon(Icons.question_answer, color: Colors.white),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(1.h), color: AppColor.primary),
                      padding: EdgeInsets.all(1.h),
                    ),
                    SizedBox(width: 5.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Information and Help", style: TextStyle(color: Colors.black, fontSize: 18.sp, fontWeight: FontWeight.bold)),
                          Text(
                            "Setup the information screen or reach us for support",
                            style: TextStyle(color: AppColor.disabled, fontSize: 12.sp, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 3.h),
              Container(
                width: 100.w,
                margin: EdgeInsets.symmetric(horizontal: 5.w),
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1.5.h),
                  color: AppColor.disabledBackground,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => Get.toNamed("/about"),
                      child: Container(
                        color: Colors.transparent,
                        padding: EdgeInsets.symmetric(vertical: 0.5.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("About Fairy Dust", style: TextStyle(color: Colors.black, fontSize: 16.sp, fontWeight: FontWeight.bold)),
                            Icon(Icons.keyboard_arrow_right, size: 5.w),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 0.5.h),
                      child: Divider(thickness: 0.1.h),
                    ),
                    GestureDetector(
                      onTap: () => Get.toNamed("/manage-info"),
                      child: Container(
                        color: Colors.transparent,
                        padding: EdgeInsets.symmetric(vertical: 0.5.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Manage Information", style: TextStyle(color: Colors.black, fontSize: 16.sp, fontWeight: FontWeight.bold)),
                            Icon(Icons.keyboard_arrow_right, size: 5.w),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
