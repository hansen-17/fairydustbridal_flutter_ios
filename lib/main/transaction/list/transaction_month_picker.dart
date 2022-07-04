import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../utils/size_util.dart';
import 'transaction_viewmodel.dart';

class TransactionMonthPicker extends StatelessWidget {
  final TransactionViewModel transactionViewModel = Get.find<TransactionViewModel>();
  final ItemScrollController itemScrollController;

  TransactionMonthPicker({required this.itemScrollController});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GetBuilder<TransactionViewModel>(
          builder: (_) {
            return Text(
              DateFormat("MMMM yyyy").format(transactionViewModel.selectedDay),
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
        IconButton(
          onPressed: () async {
            DateTime? result = await showDatePicker(context: context, initialDate: transactionViewModel.selectedDay, firstDate: DateTime(1900, 1), lastDate: DateTime(2200));
            if (result != null) {
              transactionViewModel.setSelectedDay(result);
              itemScrollController.scrollTo(index: transactionViewModel.selectedDay.day - 1, duration: Duration(milliseconds: 500), curve: Curves.easeInOutCubic);
            }
          },
          constraints: BoxConstraints(),
          icon: Icon(Icons.calendar_today),
        ),
      ],
    );
  }
}
