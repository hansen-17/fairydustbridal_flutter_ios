import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../utils/app_color.dart';
import '../../../utils/size_util.dart';
import 'create_transaction_viewmodel.dart';

class TransactionPriceSummary extends StatelessWidget {
  final CreateTransactionViewModel createTransactionViewModel = Get.find<CreateTransactionViewModel>();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Price Summary",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 2.5.h),
            Text(
              "Total Price (Adjusted)",
              style: TextStyle(
                color: Colors.black,
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 0.5.h),
            TextFormField(
              controller: createTransactionViewModel.adjustedPriceText,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(1.h), borderSide: BorderSide.none),
                contentPadding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                fillColor: AppColor.disabledBackground,
                filled: true,
                hintStyle: TextStyle(color: AppColor.disabled, fontSize: 12.sp),
                hintText: "Total Price (Adjusted)",
                prefixText: "Rp",
                prefixStyle: TextStyle(color: Colors.black, fontSize: 12.sp),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                _ThousandsSeparatorInputFormatter(),
              ],
              onTap: () => createTransactionViewModel.adjustedPriceText.selection = TextSelection(baseOffset: 0, extentOffset: createTransactionViewModel.adjustedPriceText.value.text.length),
              readOnly: false,
              style: TextStyle(color: Colors.black, fontSize: 12.sp, fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
              textInputAction: TextInputAction.done,
            ),
            SizedBox(height: 0.5.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 1.w),
              child: Container(
                width: 100.w,
                child: GetBuilder<CreateTransactionViewModel>(
                  builder: (_) {
                    return Text(
                      "*Calculated Price is Rp ${NumberFormat("#,###").format(createTransactionViewModel.calculatedPrice).replaceAll(",", ".")}",
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.sp,
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              "Discount (Percentage)",
              style: TextStyle(
                color: Colors.black,
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 0.5.h),
            TextFormField(
              controller: createTransactionViewModel.discountPercentageText,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(1.h), borderSide: BorderSide.none),
                contentPadding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                fillColor: AppColor.disabledBackground,
                filled: true,
                hintStyle: TextStyle(color: AppColor.disabled, fontSize: 12.sp),
                hintText: "Discount (Percentage)",
                suffixText: "%",
                suffixStyle: TextStyle(color: Colors.black, fontSize: 12.sp),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                _ThousandsSeparatorInputFormatter(),
              ],
              onTap: () => createTransactionViewModel.discountPercentageText.selection = TextSelection(baseOffset: 0, extentOffset: createTransactionViewModel.discountPercentageText.value.text.length),
              readOnly: false,
              style: TextStyle(color: Colors.black, fontSize: 12.sp, fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
              textInputAction: TextInputAction.done,
            ),
            SizedBox(height: 2.h),
            Text(
              "Discount (Amount)",
              style: TextStyle(
                color: Colors.black,
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 0.5.h),
            TextFormField(
              controller: createTransactionViewModel.discountAmountText,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(1.h), borderSide: BorderSide.none),
                contentPadding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                fillColor: AppColor.disabledBackground,
                filled: true,
                hintStyle: TextStyle(color: AppColor.disabled, fontSize: 12.sp),
                hintText: "Discount (Amount)",
                prefixText: "Rp",
                prefixStyle: TextStyle(color: Colors.black, fontSize: 12.sp),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                _ThousandsSeparatorInputFormatter(),
              ],
              onTap: () => createTransactionViewModel.discountAmountText.selection = TextSelection(baseOffset: 0, extentOffset: createTransactionViewModel.discountAmountText.value.text.length),
              readOnly: false,
              style: TextStyle(color: Colors.black, fontSize: 12.sp, fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
              textInputAction: TextInputAction.done,
            ),
            SizedBox(height: 2.h),
            Text(
              "Outtown Charge",
              style: TextStyle(
                color: Colors.black,
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 0.5.h),
            TextFormField(
              controller: createTransactionViewModel.outTownChargeText,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(1.h), borderSide: BorderSide.none),
                contentPadding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                fillColor: AppColor.disabledBackground,
                filled: true,
                hintStyle: TextStyle(color: AppColor.disabled, fontSize: 12.sp),
                hintText: "Outtown Charge",
                prefixText: "Rp",
                prefixStyle: TextStyle(color: Colors.black, fontSize: 12.sp),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                _ThousandsSeparatorInputFormatter(),
              ],
              onTap: () => createTransactionViewModel.outTownChargeText.selection = TextSelection(baseOffset: 0, extentOffset: createTransactionViewModel.outTownChargeText.value.text.length),
              readOnly: false,
              style: TextStyle(color: Colors.black, fontSize: 12.sp, fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
              textInputAction: TextInputAction.done,
            ),
            SizedBox(height: 2.h),
            Text(
              "Additional Price",
              style: TextStyle(
                color: Colors.black,
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 0.5.h),
            TextFormField(
              controller: createTransactionViewModel.additionalPriceText,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(1.h), borderSide: BorderSide.none),
                contentPadding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                fillColor: AppColor.disabledBackground,
                filled: true,
                hintStyle: TextStyle(color: AppColor.disabled, fontSize: 12.sp),
                hintText: "Additional Price",
                prefixText: "Rp",
                prefixStyle: TextStyle(color: Colors.black, fontSize: 12.sp),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                _ThousandsSeparatorInputFormatter(),
              ],
              onTap: () => createTransactionViewModel.additionalPriceText.selection = TextSelection(baseOffset: 0, extentOffset: createTransactionViewModel.additionalPriceText.value.text.length),
              readOnly: false,
              style: TextStyle(color: Colors.black, fontSize: 12.sp, fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
              textInputAction: TextInputAction.done,
            ),
            SizedBox(height: 2.h),
            Text(
              "Down Payment",
              style: TextStyle(
                color: Colors.black,
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 0.5.h),
            TextFormField(
              controller: createTransactionViewModel.downPaymentText,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(1.h), borderSide: BorderSide.none),
                contentPadding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                fillColor: AppColor.disabledBackground,
                filled: true,
                hintStyle: TextStyle(color: AppColor.disabled, fontSize: 12.sp),
                hintText: "Down Payment",
                prefixText: "Rp",
                prefixStyle: TextStyle(color: Colors.black, fontSize: 12.sp),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                _ThousandsSeparatorInputFormatter(),
              ],
              onTap: () => createTransactionViewModel.downPaymentText.selection = TextSelection(baseOffset: 0, extentOffset: createTransactionViewModel.downPaymentText.value.text.length),
              readOnly: false,
              style: TextStyle(color: Colors.black, fontSize: 12.sp, fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
              textInputAction: TextInputAction.done,
            ),
          ],
        ),
      ),
    );
  }
}

class _ThousandsSeparatorInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length == 0) {
      return newValue.copyWith(text: "0");
    }

    String newValueText = newValue.text.replaceAll(".", "").replaceAll(",", "");

    if (oldValue.text.endsWith(".") && oldValue.text.length == newValue.text.length + 1) {
      newValueText = newValueText.substring(0, newValueText.length - 1);
    }

    int selectionIndex = newValue.text.length - newValue.selection.extentOffset;

    String? newString = "0";
    if (double.tryParse(newValueText) != null) newString = NumberFormat("#,###").format(double.parse(newValueText));

    return TextEditingValue(
      text: newString.replaceAll(",", "."),
      selection: TextSelection.collapsed(
        offset: newString.length - selectionIndex,
      ),
    );
  }
}
