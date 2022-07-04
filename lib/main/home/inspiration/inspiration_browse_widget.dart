import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/size_util.dart';
import '../../../utils/app_color.dart';
import '../../../utils/global_controller.dart';
import 'inspiration_browse_viewmodel.dart';
import 'inspiration_card.dart';

// +================================================+
// | TODO: IMPLEMENT LAZY LOAD                      |
// +================================================+
// | THIS WIDGET HAS NOT MIPLEMENTED LAZY LOAD YET  |
// | DUE TO API RESPONSE DOESN'T SUPPORT PAGINATION |
// +================================================+

class InspirationBrowseWidget extends StatelessWidget {
  final InspirationBrowseViewModel inspirationBrowseViewModel = Get.put(InspirationBrowseViewModel());

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GetBuilder<InspirationBrowseViewModel>(builder: (_) {
            if (inspirationBrowseViewModel.isFolderView) return Container();
            return Row(
              children: [
                BackButton(onPressed: () => inspirationBrowseViewModel.triggerView(null), color: AppColor.primary),
                Expanded(
                  child: Text(
                    inspirationBrowseViewModel.selectedGroup!.name,
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
            child: GetBuilder<InspirationBrowseViewModel>(
              builder: (_) {
                if (inspirationBrowseViewModel.isLoading) return Center(child: Container(width: 5.w, height: 5.w, child: CircularProgressIndicator()));

                if (inspirationBrowseViewModel.isFolderView) {
                  return GridView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.h),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: GlobalController.instance.isPhone ? 3 : 4,
                      crossAxisCount: 2,
                      crossAxisSpacing: 5.w,
                      mainAxisSpacing: 1.h,
                    ),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTapDown: (TapDownDetails tapDownDetails) {
                          print("A");
                          inspirationBrowseViewModel.tapPosition = tapDownDetails.globalPosition;
                        },
                        child: TextButton(
                          onPressed: () {
                            inspirationBrowseViewModel.triggerView(inspirationBrowseViewModel.groups[index]);
                          },
                          onLongPress: () async {
                            RenderBox overlay = Overlay.of(context)?.context.findRenderObject() as RenderBox;
                            Get.dialog(Container());
                            String? selectedOption = await showMenu(
                              context: context,
                              position: RelativeRect.fromRect(
                                inspirationBrowseViewModel.tapPosition & Size(1.w, 1.h), // smaller rect, the touch area
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
                                Get.toNamed("/add-inspiration", arguments: inspirationBrowseViewModel.groups[index]);
                                break;
                              case "DELETE":
                                await inspirationBrowseViewModel.deleteGroup(inspirationBrowseViewModel.groups[index]);
                                break;
                              default:
                                break;
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.folder_rounded),
                              SizedBox(width: 2.w),
                              Flexible(
                                child: Text(
                                  inspirationBrowseViewModel.groups[index].name,
                                  style: TextStyle(color: AppColor.primary, fontSize: 12.sp, fontWeight: FontWeight.bold),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.white,
                            elevation: 0.5.h,
                            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                            primary: AppColor.primary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1.h)),
                            shadowColor: Color.fromARGB(255, 208, 239, 230),
                          ),
                        ),
                      );
                    },
                    itemCount: inspirationBrowseViewModel.groups.length,
                  );
                }

                return GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.h),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 1,
                    crossAxisCount: GlobalController.instance.isPhone ? 2 : 3,
                    crossAxisSpacing: 5.w,
                    mainAxisSpacing: 1.h,
                  ),
                  itemBuilder: (context, i) {
                    return InspirationCard(photoUrl: inspirationBrowseViewModel.selectedGroup!.photos[i].photoUrl);
                  },
                  itemCount: inspirationBrowseViewModel.selectedGroup!.photos.length,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
