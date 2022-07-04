import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/size_util.dart';
import 'about_viewmodel.dart';

class AboutScreen extends StatelessWidget {
  final AboutViewModel aboutViewModel = Get.put(AboutViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "About Us",
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
              color: Colors.white,
              child: GetBuilder<AboutViewModel>(
                builder: (_) {
                  if (aboutViewModel.header == "") return Center(child: Container(width: 5.w, height: 5.w, child: CircularProgressIndicator()));

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 100.w,
                        height: 35.h,
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: Image.asset("assets/images/about-background.jpg").image,
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.75), BlendMode.luminosity),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Fairy Dust Bridal",
                              style: TextStyle(color: Colors.white, fontFamily: "Niconne", fontSize: 38.sp),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "- your fairy tale awaits -",
                              style: TextStyle(color: Colors.white, fontSize: 16.sp, fontStyle: FontStyle.italic),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.5.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "WHO ARE WE ?",
                                style: TextStyle(color: Colors.black, fontSize: 20.sp, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.left,
                              ),
                              SizedBox(height: 1.h),
                              Text(
                                aboutViewModel.description,
                                style: TextStyle(color: Colors.black, fontSize: 15.sp),
                                textAlign: TextAlign.left,
                              ),
                              SizedBox(height: 5.h),
                              Container(
                                width: double.infinity,
                                child: Text(
                                  "HOW TO GET IN TOUCH ?",
                                  style: TextStyle(color: Colors.black, fontSize: 20.sp, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              SizedBox(height: 1.h),
                              Container(
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Whatsapp : ",
                                      style: TextStyle(color: Colors.black, fontSize: 15.sp),
                                      textAlign: TextAlign.left,
                                    ),
                                    SizedBox(
                                      width: 1.w,
                                    ),
                                    Text(
                                      aboutViewModel.whatsapp,
                                      style: TextStyle(color: Colors.black, fontSize: 15.sp, fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 1.h),
                              Container(
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Facebook : ",
                                      style: TextStyle(color: Colors.black, fontSize: 15.sp),
                                      textAlign: TextAlign.left,
                                    ),
                                    SizedBox(
                                      width: 1.w,
                                    ),
                                    Text(
                                      aboutViewModel.facebook,
                                      style: TextStyle(color: Colors.black, fontSize: 15.sp, fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 1.h),
                              Container(
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Instagram : ",
                                      style: TextStyle(color: Colors.black, fontSize: 15.sp),
                                      textAlign: TextAlign.left,
                                    ),
                                    SizedBox(
                                      width: 1.w,
                                    ),
                                    Text(
                                      aboutViewModel.instagram,
                                      style: TextStyle(color: Colors.black, fontSize: 15.sp, fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                              ),
                              Spacer(),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10.w),
                                width: double.infinity,
                                child: Text(
                                  "\"${aboutViewModel.header}\"",
                                  style: TextStyle(color: Colors.black, fontFamily: "Niconne", fontSize: 20.sp),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
