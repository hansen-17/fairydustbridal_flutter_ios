import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

import '../../../../utils/size_util.dart';
import '../../../models/package.dart';
import '../../../models/product.dart';
import '../../../utils/app_color.dart';
import '../../../utils/global_controller.dart';
import '../product_service/product/product_card.dart';
import '../product_service/service/service_card.dart';
import 'package_browse_viewmodel.dart';
import 'package_card.dart';

class PackageBrowseWidget extends StatelessWidget {
  final PackageBrowseViewModel packageBrowseViewModel = Get.put(PackageBrowseViewModel());

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GetBuilder<PackageBrowseViewModel>(builder: (_) {
            if (packageBrowseViewModel.isFolderView) return Container();
            return Row(
              children: [
                BackButton(onPressed: () => packageBrowseViewModel.triggerView(null), color: AppColor.primary),
                Expanded(
                  child: Text(
                    packageBrowseViewModel.selectedPackage!.name,
                    style: TextStyle(color: AppColor.primary, fontSize: 14.sp, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.fade,
                  ),
                ),
              ],
            );
          }),
          Expanded(
            child: GetBuilder<PackageBrowseViewModel>(
              builder: (_) {
                if (packageBrowseViewModel.isLoading) return Center(child: Container(width: 5.w, height: 5.w, child: CircularProgressIndicator()));

                if (packageBrowseViewModel.isFolderView) {
                  return LazyLoadScrollView(
                    onEndOfPage: () => packageBrowseViewModel.loadMorePackages(),
                    child: GridView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.h),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: GlobalController.instance.isPhone ? 0.75 : 0.85,
                        crossAxisCount: GlobalController.instance.isPhone ? 2 : 2,
                        crossAxisSpacing: 5.w,
                        mainAxisSpacing: 1.h,
                      ),
                      itemBuilder: (context, index) {
                        if (packageBrowseViewModel.packages[index].id == "") return Center(child: Container(width: 5.w, height: 5.w, child: CircularProgressIndicator()));

                        return PackageCard(
                          package: packageBrowseViewModel.packages[index],
                          onTap: () => packageBrowseViewModel.triggerView(packageBrowseViewModel.packages[index]),
                        );
                      },
                      itemCount: packageBrowseViewModel.packages.length,
                    ),
                  );
                }

                return GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.h),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: GlobalController.instance.isPhone ? 0.8 : 0.75,
                    crossAxisCount: GlobalController.instance.isPhone ? 2 : 3,
                    crossAxisSpacing: 5.w,
                    mainAxisSpacing: 1.h,
                  ),
                  itemBuilder: (context, index) {
                    dynamic item = packageBrowseViewModel.selectedPackage!.allItems[index];

                    if (item is PackageDetailService)
                      return ServiceCard(service: packageBrowseViewModel.selectedPackage!.allItems[index].service);
                    else /*(item is PackageDetailProduct)*/ {
                      return ProductCard(product: Product(id: "", code: "1 pcs", type: item.type, category: item.category, photos: []));
                    }
                  },
                  itemCount: packageBrowseViewModel.selectedPackage!.allItems.length,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
