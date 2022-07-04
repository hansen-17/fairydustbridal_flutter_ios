import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

import '../../../../utils/app_color.dart';
import '../../../../utils/custom_dropdown.dart';
import '../../../../utils/global_controller.dart';
import '../../../../utils/size_util.dart';
import 'service_browse_viewmodel.dart';
import 'service_card.dart';

class ServiceBrowseWidget extends StatelessWidget {
  final ServiceBrowseViewModel serviceBrowseViewModel = Get.put(ServiceBrowseViewModel());

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 1.w),
                  child: Text("Service Type : ", style: serviceBrowseViewModel.selectButtonTextStyle),
                ),
              ),
              Expanded(child: Container()),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: GetBuilder<ServiceBrowseViewModel>(
                  builder: (_) {
                    return serviceBrowseViewModel.serviceTypeItems.isEmpty
                        ? Container()
                        : CustomDropdown<dynamic>(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.h),
                              child: Text(
                                serviceBrowseViewModel.selectedType.name,
                                style: serviceBrowseViewModel.selectButtonTextStyle,
                                maxLines: 1,
                                overflow: TextOverflow.fade,
                                softWrap: false,
                              ),
                            ),
                            onChange: (dynamic value, int index) => serviceBrowseViewModel.setServiceType(value),
                            dropdownButtonStyle: DropdownButtonStyle(
                              elevation: 0.5.h,
                              backgroundColor: Colors.white,
                              primaryColor: AppColor.primary,
                            ),
                            dropdownStyle: DropdownStyle(
                              borderRadius: BorderRadius.circular(1.h),
                              elevation: 0.5.h,
                              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                            ),
                            items: serviceBrowseViewModel.serviceTypeItems,
                          );
                  },
                ),
              ),
              Expanded(child: Container()),
            ],
          ),
          SizedBox(height: 2.h),
          Expanded(
            child: GetBuilder<ServiceBrowseViewModel>(
              builder: (_) {
                if (serviceBrowseViewModel.isLoading) return Center(child: Container(width: 5.w, height: 5.w, child: CircularProgressIndicator()));

                return LazyLoadScrollView(
                  onEndOfPage: () => serviceBrowseViewModel.loadMoreService(),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: GlobalController.instance.isPhone ? 0.8 : 0.75,
                      crossAxisCount: GlobalController.instance.isPhone ? 2 : 3,
                      crossAxisSpacing: 5.w,
                      mainAxisSpacing: 1.h,
                    ),
                    itemBuilder: (context, index) {
                      if (serviceBrowseViewModel.services[index].id == "") return Center(child: Container(width: 5.w, height: 5.w, child: CircularProgressIndicator()));

                      return ServiceCard(service: serviceBrowseViewModel.services[index], clickable: true);
                    },
                    itemCount: serviceBrowseViewModel.services.length,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
