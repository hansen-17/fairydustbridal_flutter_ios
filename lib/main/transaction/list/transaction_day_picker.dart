import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../utils/app_color.dart';
import '../../../utils/global_controller.dart';
import '../../../utils/size_util.dart';
import 'transaction_viewmodel.dart';

class TransactionDayPicker extends StatelessWidget {
  final TransactionViewModel transactionViewModel = Get.find<TransactionViewModel>();
  final ItemScrollController itemScrollController;
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();

  TransactionDayPicker({required this.itemScrollController});

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance?.addPostFrameCallback((_) {
      itemScrollController.scrollTo(index: transactionViewModel.selectedDay.day - 1, duration: Duration(milliseconds: 500), curve: Curves.easeInOutCubic);
    });

    return GetBuilder<TransactionViewModel>(
      builder: (_) {
        return Container(
          height: GlobalController.instance.isPhone ? 14.w : 12.w,
          child: ScrollablePositionedList.builder(
            scrollDirection: Axis.horizontal,
            itemCount: transactionViewModel.numberOfDays,
            itemBuilder: (context, index) {
              final String daysOfWeek = DateFormat("EE").format(
                DateTime(
                  transactionViewModel.selectedDay.year,
                  transactionViewModel.selectedDay.month,
                  index + 1,
                ),
              );

              return Card(
                elevation: 0.5.h,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1.h)),
                margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                child: InkWell(
                  onTap: () {
                    transactionViewModel.setSelectedDay(DateTime(transactionViewModel.selectedDay.year, transactionViewModel.selectedDay.month, index + 1));
                    itemScrollController.scrollTo(index: index, duration: Duration(milliseconds: 500), curve: Curves.easeInOutCubic);
                  },
                  borderRadius: BorderRadius.circular(1.h),
                  child: Container(
                    width: GlobalController.instance.isPhone ? 12.w : 10.w,
                    height: GlobalController.instance.isPhone ? 12.w : 10.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(1.h),
                      color: transactionViewModel.selectedDay.day == index + 1 ? AppColor.primary.withOpacity(0.25) : Colors.transparent,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            daysOfWeek,
                            style: TextStyle(
                              color: daysOfWeek == "Sun"
                                  ? Colors.red
                                  : daysOfWeek == "Sat"
                                      ? AppColor.primary
                                      : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            "${index + 1}",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
            itemScrollController: itemScrollController,
            itemPositionsListener: itemPositionsListener,
          ),
        );
      },
    );
  }
}
