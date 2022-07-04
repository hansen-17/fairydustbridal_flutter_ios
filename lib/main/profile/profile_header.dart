import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/app_color.dart';
import '../../utils/loading_button.dart';
import '../../utils/size_util.dart';
import 'profile_viewmodel.dart';

class ProfileHeader extends StatelessWidget {
  final ProfileViewModel profileViewModel = Get.find<ProfileViewModel>();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.5.h,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1.h)),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  minRadius: 7.5.w,
                  maxRadius: 7.5.w,
                  backgroundColor: AppColor.disabledBackground,
                  child: Text(
                    profileViewModel.user != null ? profileViewModel.user!.name[0].toUpperCase() : "G",
                    style: TextStyle(color: Colors.black, fontSize: 20.sp, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(width: 5.w),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profileViewModel.user != null ? profileViewModel.user!.name[0].toUpperCase() + profileViewModel.user!.name.substring(1) : "Guest",
                      style: TextStyle(color: Colors.black, fontSize: 20.sp, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      profileViewModel.user != null ? profileViewModel.user!.email ?? "Email : -" : "Email : -",
                      style: TextStyle(color: Colors.black, fontSize: 12.sp),
                    ),
                    Text(
                      profileViewModel.user != null
                          ? profileViewModel.user!.isEmailVerified
                              ? "Email not verified!"
                              : "Email already verified!"
                          : "No email registered yet!",
                      style: TextStyle(
                        color: profileViewModel.user != null
                            ? profileViewModel.user!.isEmailVerified
                                ? Colors.red
                                : AppColor.primary
                            : Colors.black,
                        fontSize: 11.sp,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.mail),
                        SizedBox(width: 2.w),
                        Text("Send Verification", style: TextStyle(color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: AppColor.primary,
                      elevation: 0.5.h,
                      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                      primary: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1.h)),
                      shadowColor: Color.fromARGB(255, 208, 239, 230),
                    ),
                  ),
                ),
                SizedBox(width: 5.w),
                Expanded(
                  child: LoadingButton(
                    textButton: TextButton(
                      onPressed: () async {
                        await profileViewModel.logout();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout),
                          SizedBox(width: 2.w),
                          Text("Log Out", style: TextStyle(color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: AppColor.primary,
                        elevation: 0.5.h,
                        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                        primary: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1.h)),
                        shadowColor: Color.fromARGB(255, 208, 239, 230),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
