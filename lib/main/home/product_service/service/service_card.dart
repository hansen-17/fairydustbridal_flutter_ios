import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../models/service.dart';
import '../../../../utils/app_color.dart';
import '../../../../utils/size_util.dart';
import 'service_browse_viewmodel.dart';

class ServiceCard extends StatelessWidget {
  final Service service;
  final bool clickable;
  ServiceCard({required this.service, this.clickable = false});

  final ServiceBrowseViewModel serviceBrowseViewModel = Get.find<ServiceBrowseViewModel>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          elevation: 0.5.h,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1.h)),
          child: Material(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(1.h)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 1.2,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(1.h),
                          topRight: Radius.circular(1.h),
                        ),
                        image: DecorationImage(
                          image: Image.network(service.photo!.photoUrl).image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            service.description,
                            style: TextStyle(color: AppColor.primary, fontSize: 14.sp, fontWeight: FontWeight.bold),
                            maxLines: 2,
                            overflow: TextOverflow.fade,
                          ),
                          Expanded(child: Container()),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 0.25.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(0.5.h),
                              color: AppColor.primary,
                            ),
                            child: Text(
                              service.type != null ? service.type!.name : "",
                              style: TextStyle(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.fade,
                              softWrap: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Container(
            padding: EdgeInsets.all(0.5.h),
            child: Material(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1.h)),
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(1.h),
                onTap: () {
                  if (clickable) Get.toNamed("/service-photo", arguments: service.photo!.photoUrl);
                },
                onTapDown: (TapDownDetails tapDownDetails) {
                  serviceBrowseViewModel.tapPosition = tapDownDetails.globalPosition;
                },
                onLongPress: () async {
                  if (!clickable) return;
                  RenderBox overlay = Overlay.of(context)?.context.findRenderObject() as RenderBox;
                  Get.dialog(Container());
                  String? selectedOption = await showMenu(
                    context: context,
                    position: RelativeRect.fromRect(
                      serviceBrowseViewModel.tapPosition & Size(1.w, 1.h), // smaller rect, the touch area
                      Offset.zero & overlay.size,
                    ),
                    items: [
                      PopupMenuItem(
                        value: "EDIT",
                        child: Text(
                          "EDIT",
                          style: TextStyle(color: Colors.black, fontSize: 12.sp, fontWeight: FontWeight.bold),
                        ),
                      ),
                      PopupMenuItem(
                        value: "DELETE",
                        child: Text(
                          "DELETE",
                          style: TextStyle(color: Colors.black, fontSize: 12.sp, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  );
                  Get.back();
                  switch (selectedOption) {
                    case "EDIT":
                      Get.toNamed("/add-service", arguments: service);
                      break;
                    case "DELETE":
                      await serviceBrowseViewModel.deleteService(service);
                      break;
                    default:
                      break;
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
