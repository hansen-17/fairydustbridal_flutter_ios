import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/app_color.dart';
import '../../utils/loading_button.dart';
import '../../utils/size_util.dart';
import 'login_viewmodel.dart';

class LoginScreen extends StatelessWidget {
  final LoginViewModel loginViewModel = Get.put(LoginViewModel());
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
        body: Stack(
          children: [
            Image.asset(
              "assets/images/login-background.jpg",
              width: 100.w,
              height: 30.h,
              color: Colors.black.withOpacity(0.4),
              colorBlendMode: BlendMode.luminosity,
              fit: BoxFit.cover,
            ),
            Container(
              width: 100.w,
              height: 25.h,
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Fairy Dust Bridal",
                    style: TextStyle(color: Colors.white, fontFamily: "Niconne", fontSize: 36.sp),
                  ),
                  Text(
                    "Your fairy tale awaits",
                    style: TextStyle(color: Colors.white, fontSize: 14.sp, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 25.h),
                  Container(
                    width: 100.w,
                    height: 75.h + SizeUtil.statusBarHeight(),
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
                          Text(
                            "Log In",
                            style: TextStyle(color: AppColor.primary, fontSize: 24.sp, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 3.h),
                          GetBuilder<LoginViewModel>(
                            builder: (_) {
                              return TextFormField(
                                controller: loginViewModel.emailText,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(1.h), borderSide: BorderSide.none),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                                  fillColor: AppColor.disabledBackground,
                                  filled: true,
                                  hintStyle: TextStyle(color: AppColor.disabled),
                                  hintText: "Email",
                                  prefixIcon: Icon(Icons.person),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                onChanged: (_) => _loginFormKey.currentState!.validate(),
                                style: TextStyle(color: Colors.black, fontSize: 14.sp, fontWeight: FontWeight.bold),
                                textInputAction: TextInputAction.next,
                                validator: (_) => loginViewModel.validateEmail(),
                              );
                            },
                          ),
                          SizedBox(height: 3.h),
                          GetBuilder<LoginViewModel>(
                            builder: (_) {
                              return TextFormField(
                                controller: loginViewModel.passwordText,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(1.h), borderSide: BorderSide.none),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                                  fillColor: AppColor.disabledBackground,
                                  filled: true,
                                  hintStyle: TextStyle(color: AppColor.disabled),
                                  hintText: "Password",
                                  prefixIcon: Icon(Icons.lock),
                                ),
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: true,
                                onChanged: (_) => _loginFormKey.currentState!.validate(),
                                style: TextStyle(color: Colors.black, fontSize: 14.sp, fontWeight: FontWeight.bold),
                                textInputAction: TextInputAction.done,
                                validator: (_) => loginViewModel.validatePassword(),
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
                                    if (loginViewModel.isLoading) return;

                                    loginViewModel.startValidation();
                                    if (_loginFormKey.currentState!.validate()) {
                                      await loginViewModel.login();
                                    }
                                  },
                                  child: Text(
                                    "LOG IN",
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
                          SizedBox(height: 1.h),
                          Row(
                            children: [
                              Expanded(child: Container(height: 0.1.h, color: AppColor.primary)),
                              SizedBox(width: 3.w),
                              Text(
                                "OR",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 3.w),
                              Expanded(child: Container(height: 0.1.h, color: AppColor.primary)),
                            ],
                          ),
                          SizedBox(height: 1.h),
                          Center(
                            child: SizedBox(
                              width: 100.w,
                              child: TextButton(
                                onPressed: () => loginViewModel.loginAsGuest(),
                                child: Text(
                                  "Log In As Guest",
                                  style: TextStyle(color: Colors.black, fontSize: 16.sp, fontWeight: FontWeight.bold),
                                ),
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  elevation: 0.35.h,
                                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.5.h),
                                  shadowColor: Color.fromARGB(255, 208, 239, 230),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1.h)),
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
          ],
        ),
      ),
    );
  }
}
