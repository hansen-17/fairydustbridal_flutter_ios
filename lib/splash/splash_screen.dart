import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/size_util.dart';
import 'splash_viewmodel.dart';

class SplashScreen extends StatelessWidget {
  final SplashViewModel splashViewModel = Get.put(SplashViewModel());

  @override
  Widget build(BuildContext context) {
    SizeUtil.init(context);

    return AnimatedSplashScreen(
      backgroundColor: Colors.white,
      disableNavigation: true,
      nextScreen: this,
      splash: Image.asset(
        "assets/images/logo.png",
        width: 70.w,
        fit: BoxFit.fill,
      ),
      splashIconSize: 65.w,
    );
  }
}
