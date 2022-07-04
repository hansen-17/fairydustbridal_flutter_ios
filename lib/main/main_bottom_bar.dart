import 'main_viewmodel.dart';
import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/app_color.dart';
import '../utils/size_util.dart';

class MainBottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainViewModel>(
      builder: (MainViewModel mainViewModel) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            FluidNavBar(
              style: FluidNavBarStyle(barBackgroundColor: AppColor.primary.withOpacity(0.5)),
              icons: [
                FluidNavBarIcon(
                  icon: Icons.dashboard_outlined,
                  backgroundColor: mainViewModel.selectedIndex == 0 ? AppColor.primary : Colors.transparent,
                  selectedForegroundColor: mainViewModel.selectedIndex == 0 ? Colors.white : Colors.black,
                  unselectedForegroundColor: mainViewModel.selectedIndex == 0 ? Colors.white : Colors.black,
                ),
                FluidNavBarIcon(
                  icon: Icons.home_outlined,
                  backgroundColor: mainViewModel.selectedIndex == 1 ? AppColor.primary : Colors.transparent,
                  selectedForegroundColor: mainViewModel.selectedIndex == 1 ? Colors.white : Colors.black,
                  unselectedForegroundColor: mainViewModel.selectedIndex == 1 ? Colors.white : Colors.black,
                ),
                FluidNavBarIcon(
                  icon: Icons.person_outline,
                  backgroundColor: mainViewModel.selectedIndex == 2 ? AppColor.primary : Colors.transparent,
                  selectedForegroundColor: mainViewModel.selectedIndex == 2 ? Colors.white : Colors.black,
                  unselectedForegroundColor: mainViewModel.selectedIndex == 2 ? Colors.white : Colors.black,
                ),
              ],
              animationFactor: 0.5,
              defaultIndex: 1,
              onChange: (index) => mainViewModel.navigateToIndex(index),
              scaleFactor: 1.0,
            ),
            Container(
              height: 2.h,
              color: AppColor.primary.withOpacity(0.5),
            ),
          ],
        );
      },
    );
  }
}
