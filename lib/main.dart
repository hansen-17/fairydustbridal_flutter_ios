import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

import 'auth/login/login_screen.dart';
import 'main/home/inspiration/add/add_inspiration_screen.dart';
import 'main/home/package/add/add_package_screen.dart';
import 'main/home/product_service/product/add/add_product_screen.dart';
import 'main/home/product_service/product/product_detail/product_detail_screen.dart';
import 'main/home/product_service/product/product_detail/product_photo_screen.dart';
import 'main/home/product_service/product/search/scan_qr_screen.dart';
import 'main/home/product_service/product/search/search_product_screen.dart';
import 'main/home/product_service/service/add/add_service_screen.dart';
import 'main/home/product_service/service/service_detail/service_photo_screen.dart';
import 'main/main_screen.dart';
import 'main/profile/about/about_screen.dart';
import 'main/profile/change_password/change_password_screen.dart';
import 'main/profile/manage_info/manage_info_screen.dart';
import 'main/transaction/create/create_transaction_screen.dart';
import 'splash/splash_screen.dart';
import 'utils/api_service.dart';
import 'utils/app_color.dart';
import 'utils/global_controller.dart';
import 'utils/storage_service.dart';

Future<void> main() async {
  await initServices();

  Get.put(GlobalController());
  runApp(MyApp());
}

Future<void> initServices() async {
  Get.put(ApiService());
  await Get.putAsync(() => StorageService().initStorage());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData(fontFamily: "ProximaNova");

    return GetMaterialApp(
      builder: (BuildContext context, Widget? child) {
        return FlutterSmartDialog(child: child);
      },
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.cupertino,
      initialRoute: "/splash",
      theme: theme.copyWith(
        // accentColor: AppColor.primary,
        buttonTheme: ButtonThemeData(
          buttonColor: AppColor.primary,
          textTheme: ButtonTextTheme.primary,
        ),
        colorScheme: theme.colorScheme.copyWith(
          primary: AppColor.primary,
        ),
        primaryColor: AppColor.primary,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: AppColor.primary,
          selectionColor: AppColor.primary,
          selectionHandleColor: AppColor.primary,
        ),
      ),
      title: "Fairy Dust Bridal",
      getPages: [
        GetPage(name: "/main", page: () => MainScreen()),
        GetPage(name: "/splash", page: () => SplashScreen()),
        GetPage(name: "/login", page: () => LoginScreen()),
        GetPage(name: "/product-detail", page: () => ProductDetailScreen()),
        GetPage(name: "/add-product", page: () => AddProductScreen()),
        GetPage(name: "/search-product", page: () => SearchProductScreen()),
        GetPage(name: "/scan-qr", page: () => ScanQrScreen()),
        GetPage(name: "/product-photo", page: () => ProductPhotoScreen()),
        GetPage(name: "/add-service", page: () => AddServiceScreen()),
        GetPage(name: "/service-photo", page: () => ServicePhotoScreen()),
        GetPage(name: "/add-inspiration", page: () => AddInspirationScreen()),
        GetPage(name: "/add-package", page: () => AddPackageScreen()),
        GetPage(
            name: "/create-transaction", page: () => CreateTransactionScreen()),
        GetPage(name: "/change-password", page: () => ChangePasswordScreen()),
        GetPage(name: "/about", page: () => AboutScreen()),
        GetPage(name: "/manage-info", page: () => ManageInfoScreen()),
      ],
    );
  }
}
