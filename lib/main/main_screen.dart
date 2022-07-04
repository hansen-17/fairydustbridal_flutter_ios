import '../utils/app_color.dart';
import '../utils/size_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/global_controller.dart';
import 'main_bottom_bar.dart';
import 'main_viewmodel.dart';

class MainScreen extends StatefulWidget {
  static const snackBarDuration = Duration(seconds: 3);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final MainViewModel mainViewModel = Get.put(MainViewModel());

  DateTime? backButtonPressTime;

  @override
  Widget build(BuildContext context) {
    GlobalController.instance.isPhone = MediaQuery.of(context).size.shortestSide < 600;

    return GetBuilder<MainViewModel>(
      builder: (_) {
        return WillPopScope(
          onWillPop: () {
            return handleWillPop();
            // DateTime now = DateTime.now();
            // DateTime? currentBackPressTime;
            // if (currentBackPressTime == null || now.difference(currentBackPressTime) > Duration(seconds: 2)) {
            //   currentBackPressTime = now;
            //   Get.snackbar(
            //     "Exit Application?",
            //     "Press back one more time to exit!",
            //     messageText: Text("Press back one more time to exit!", style: TextStyle(fontStyle: FontStyle.italic)),
            //     margin: EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
            //     backgroundColor: AppColor.snackbarBackground,
            //     snackPosition: SnackPosition.BOTTOM,
            //   );
            //   return Future.value(false);
            // }
            // return Future.value(true);
          },
          child: Scaffold(
            bottomNavigationBar: MainBottomBar(),
            body: mainViewModel.selectedFragment,
          ),
        );
      },
    );
  }

  Future<bool> handleWillPop() async {
    final now = DateTime.now();
    bool backButtonHasNotBeenPressedOrSnackBarHasBeenClosed;
    if (backButtonPressTime == null) {
      backButtonHasNotBeenPressedOrSnackBarHasBeenClosed = true;
    } else {
      backButtonHasNotBeenPressedOrSnackBarHasBeenClosed = (now.difference(backButtonPressTime!) > MainScreen.snackBarDuration);
    }

    if (backButtonHasNotBeenPressedOrSnackBarHasBeenClosed) {
      backButtonPressTime = now;
      Get.snackbar(
        "Exit Application?",
        "Press back one more time to exit!",
        messageText: Text("Press back one more time to exit!", style: TextStyle(fontStyle: FontStyle.italic)),
        margin: EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
        backgroundColor: AppColor.snackbarBackground,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    return true;
  }
}
