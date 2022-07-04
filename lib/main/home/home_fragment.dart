import 'package:drawerbehavior/drawerbehavior.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/app_color.dart';
import '../../utils/size_util.dart';
import 'home_viewmodel.dart';

class HomeFragment extends StatelessWidget {
  final HomeViewModel homeViewModel = Get.put(HomeViewModel());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeViewModel>(
      builder: (_) {
        return DrawerScaffold(
          appBar: AppBar(
            actions: [
              Container(
                margin: EdgeInsets.only(right: 2.5.w),
                child: IconButton(
                  onPressed: () => Get.toNamed("/search-product"),
                  icon: Icon(Icons.search),
                  color: Colors.white,
                ),
              ),
            ],
            backgroundColor: AppColor.primary,
            centerTitle: true,
            elevation: 1.h,
            leadingWidth: 17.5.w,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(2.5.h),
                bottomRight: Radius.circular(2.5.h),
              ),
            ),
            title: Text(
              "Fairy Dust Bridal",
              style: TextStyle(
                color: Colors.white,
                fontFamily: "Niconne",
                fontSize: 28.sp,
              ),
            ),
            toolbarHeight: 10.h,
          ),
          builder: (context, id) {
            return Container(
              height: 100.h,
              width: 100.w,
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
              child: homeViewModel.selectedWidget,
            );
          },
          drawers: [
            SideDrawer(
              alignment: Alignment.topLeft,
              animation: true,
              cornerRadius: 2.5.h,
              color: AppColor.primary.withOpacity(0.1),
              degree: 25,
              direction: Direction.left,
              headerView: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColor.primary,
                      child: Text(
                        homeViewModel.user != null ? homeViewModel.user!.name[0].toUpperCase() : "G",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          homeViewModel.user != null ? homeViewModel.user!.name[0].toUpperCase() + homeViewModel.user!.name.substring(1) : "Guest",
                          style: TextStyle(color: Colors.black, fontSize: 20.sp, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          homeViewModel.user != null ? homeViewModel.user!.email ?? "-" : "-",
                          style: TextStyle(color: Colors.black, fontSize: 12.sp, fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              menu: Menu(items: homeViewModel.menuItems),
              onMenuItemSelected: (dynamic itemId) => homeViewModel.setItemId(itemId),
              percentage: 1,
              selectorColor: AppColor.primary,
              selectedItemId: homeViewModel.selectedItemId,
              slide: true,
            )
          ],
          floatingActionButton: (homeViewModel.selectedItemId != "1")
              ? FloatingActionButton(
                  onPressed: () {
                    switch (homeViewModel.selectedItemId) {
                      case "1a":
                        Get.toNamed("/add-product");
                        break;
                      case "1b":
                        Get.toNamed("/add-service");
                        break;
                      case "1c":
                        Get.toNamed("/add-service");
                        break;
                      case "1d":
                        Get.toNamed("/add-service");
                        break;
                      case "2":
                        Get.toNamed("/add-package");
                        break;
                      case "3":
                        Get.toNamed("/add-inspiration");
                        break;
                    }
                  },
                  backgroundColor: AppColor.primary,
                  child: Icon(Icons.add, color: Colors.white),
                )
              : Container(),
        );
      },
    );
  }
}
