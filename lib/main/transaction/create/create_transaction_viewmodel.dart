import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart' hide Response;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../models/customer.dart';
import '../../../models/package.dart';
import '../../../models/product.dart';
import '../../../models/service.dart';
import '../../../models/transaction.dart';
import '../../../utils/api_service.dart';
import '../../../utils/app_color.dart';
import '../../../utils/size_util.dart';
import '../list/transaction_viewmodel.dart';

class CreateTransactionViewModel extends GetxController {
  TextEditingController customerNameText = TextEditingController(text: "");
  TextEditingController packageNameText = TextEditingController(text: "");

  bool isEdit = false;

  late int _id;
  int get id => _id;

  late DateTime _transactionDate;

  Customer? _customer;
  Customer? get customer => _customer;
  void setCustomer(Customer customer) {
    _customer = customer;
    customerNameText.text = customer.name;
    update();
  }

  Package? _package;
  Package? get package => _package;
  void setPackage(Package package) {
    _package = package;
    packageNameText.text = package.name;

    detailTransactionProducts.clear();
    package.products!.forEach(
      (PackageDetailProduct packageDetailProduct) {
        _detailTransactionProducts.add(
          DetailTransactionProduct(
            id: "",
            product: Product(
                id: "",
                code: "Please choose a product",
                type: packageDetailProduct.type,
                category: packageDetailProduct.category),
            rentDate: DateTime.now(),
            returnDate: DateTime.now(),
          ),
        );
      },
    );

    detailTransactionServices.clear();
    package.services!.forEach(
      (PackageDetailService packageDetailService) {
        _detailTransactionServices.add(
          DetailTransactionService(
            id: "",
            service: packageDetailService.service,
            beginDate: DateTime.now(),
            endDate: DateTime.now(),
          ),
        );
      },
    );

    calculatePrice();
    update();
  }

  List<DetailTransactionProduct> _detailTransactionProducts = [];
  List<DetailTransactionProduct> get detailTransactionProducts =>
      _detailTransactionProducts;
  void addDetailProduct(
      {required Product product,
      required DateTime rentDate,
      required DateTime returnDate,
      required String description}) {
    _detailTransactionProducts.add(new DetailTransactionProduct(
        id: "",
        product: product,
        rentDate: rentDate,
        returnDate: returnDate,
        description: description));
    calculatePrice();
    update();
  }

  void updateDetailProduct({
    required DetailTransactionProduct detailTransactionProduct,
    required Product product,
    required DateTime rentDate,
    required DateTime returnDate,
    required String description,
  }) {
    detailTransactionProduct.product = product;
    detailTransactionProduct.rentDate = rentDate;
    detailTransactionProduct.returnDate = returnDate;
    detailTransactionProduct.description = description;
    calculatePrice();
    update();
  }

  void removeDetailProduct(DetailTransactionProduct detailTransactionProduct) {
    _detailTransactionProducts.remove(detailTransactionProduct);
    calculatePrice();
    update();
  }

  List<DetailTransactionService> _detailTransactionServices = [];
  List<DetailTransactionService> get detailTransactionServices =>
      _detailTransactionServices;
  void addDetailService(
      {required Service service,
      required DateTime beginDate,
      required DateTime endDate,
      required String description}) {
    _detailTransactionServices.add(new DetailTransactionService(
        id: "",
        service: service,
        beginDate: beginDate,
        endDate: endDate,
        description: description));
    calculatePrice();
    update();
  }

  void updateDetailService({
    required DetailTransactionService detailTransactionService,
    required Service service,
    required DateTime beginDate,
    required DateTime endDate,
    required String description,
  }) {
    detailTransactionService.service = service;
    detailTransactionService.beginDate = beginDate;
    detailTransactionService.endDate = endDate;
    detailTransactionService.description = description;
    calculatePrice();
    update();
  }

  void removeDetailService(DetailTransactionService detailTransactionService) {
    _detailTransactionServices.remove(detailTransactionService);
    calculatePrice();
    update();
  }

  double _calculatedPrice = 0;
  double get calculatedPrice => _calculatedPrice;
  void calculatePrice() {
    _calculatedPrice = 0;
    detailTransactionProducts.forEach(
        (DetailTransactionProduct detailTransactionProduct) =>
            _calculatedPrice += detailTransactionProduct.product.price);
    detailTransactionServices.forEach(
        (DetailTransactionService detailTransactionService) =>
            _calculatedPrice += detailTransactionService.service.price);
    _calculatedPrice = package?.price ?? 0;
  }

  TextEditingController adjustedPriceText = TextEditingController(text: "0");
  TextEditingController discountPercentageText =
      TextEditingController(text: "0");
  TextEditingController discountAmountText = TextEditingController(text: "0");
  TextEditingController outTownChargeText = TextEditingController(text: "0");
  TextEditingController additionalPriceText = TextEditingController(text: "0");
  TextEditingController downPaymentText = TextEditingController(text: "0");

  double _finalPrice = 0;
  double get finalPrice => _finalPrice;

  void calculateFinalPrice() {
    double adjustedPrice =
        double.tryParse(adjustedPriceText.text.replaceAll(".", "")) ?? 0;
    double discountPercentage =
        double.tryParse(discountPercentageText.text.replaceAll(".", "")) ?? 0;
    double discountAmount =
        double.tryParse(discountAmountText.text.replaceAll(".", "")) ?? 0;
    double outTownCharge =
        double.tryParse(outTownChargeText.text.replaceAll(".", "")) ?? 0;
    double additionalPrice =
        double.tryParse(additionalPriceText.text.replaceAll(".", "")) ?? 0;

    _finalPrice = adjustedPrice -
        (discountPercentage / 100 * adjustedPrice) -
        (discountAmount) +
        outTownCharge +
        additionalPrice;
    update();
  }

  bool _loading = false;
  bool get isLoading => _loading;
  void triggerLoading() {
    _loading = !_loading;
    update();
  }

  Transaction? transaction;

  @override
  void onInit() {
    super.onInit();
    loadAbout();
    transaction = Get.arguments;
    if (transaction != null) {
      isEdit = true;
      _id = transaction!.id;
      _transactionDate = transaction!.transactionDate;
      setCustomer(transaction!.customer);
      _package = transaction!.package;
      packageNameText.text = transaction!.package?.name ?? "";
      _detailTransactionProducts = transaction!.transactionProducts;
      _detailTransactionServices = transaction!.transactionServices;
      adjustedPriceText.text = NumberFormat("#,###")
          .format(transaction!.adjustedPrice)
          .replaceAll(",", ".");
      _calculatedPrice = transaction!.calculatedPrice;
      discountPercentageText.text = NumberFormat("#,###")
          .format(transaction!.discountPercentage)
          .replaceAll(",", ".");
      discountAmountText.text = NumberFormat("#,###")
          .format(transaction!.discountAmount)
          .replaceAll(",", ".");
      outTownChargeText.text = NumberFormat("#,###")
          .format(transaction!.outTownCharge)
          .replaceAll(",", ".");
      additionalPriceText.text = NumberFormat("#,###")
          .format(transaction!.additionalPrice)
          .replaceAll(",", ".");
      downPaymentText.text = NumberFormat("#,###")
          .format(transaction!.downPayment)
          .replaceAll(",", ".");
      _finalPrice = transaction!.grandTotal;
    }

    adjustedPriceText.addListener(() => calculateFinalPrice());
    discountPercentageText.addListener(() => calculateFinalPrice());
    discountAmountText.addListener(() => calculateFinalPrice());
    outTownChargeText.addListener(() => calculateFinalPrice());
    additionalPriceText.addListener(() => calculateFinalPrice());
    downPaymentText.addListener(() => calculateFinalPrice());
  }

  String header = "";
  String description = "";
  String whatsapp = "";
  String facebook = "";
  String instagram = "";

  Future<void> loadAbout() async {
    triggerLoading();
    dynamic result = (await ApiService.me.get("master/about-us")).body;
    triggerLoading();

    if (result != null) {
      header = result["data"]["header"];
      description = result["data"]["description"];
      whatsapp = result["data"]["whatsapp"];
      facebook = result["data"]["facebook"];
      instagram = result["data"]["instagram"];
    }
  }

  bool validateForm() {
    if (_customer == null) {
      Get.snackbar("Validation Error", "Customer cannot be empty!",
          messageText: Text("Customer cannot be empty!",
              style: TextStyle(fontStyle: FontStyle.italic)),
          margin: EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
          backgroundColor: AppColor.snackbarBackground,
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }

    if (_detailTransactionProducts.length == 0 &&
        _detailTransactionServices.length == 0) {
      Get.snackbar("Validation Error",
          "At least 1 product or service is needed to proceed!",
          messageText: Text(
              "At least 1 product or service is needed to proceed!",
              style: TextStyle(fontStyle: FontStyle.italic)),
          margin: EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
          backgroundColor: AppColor.snackbarBackground,
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }

    List<DetailTransactionProduct> emptyProducts = [];
    emptyProducts = _detailTransactionProducts
        .where((DetailTransactionProduct detailTransactionProduct) =>
            detailTransactionProduct.product.id == "")
        .toList();

    if (emptyProducts.length > 0) {
      Get.snackbar("Validation Error",
          "${emptyProducts.length} unselected product(s) remaining!",
          messageText: Text(
              "${emptyProducts.length} unselected product(s) remaining!",
              style: TextStyle(fontStyle: FontStyle.italic)),
          margin: EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
          backgroundColor: AppColor.snackbarBackground,
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }

    if (_finalPrice <= 0) {
      Get.snackbar("Validation Error", "Grand Total should be > 0!",
          messageText: Text("Grand Total should be > 0!",
              style: TextStyle(fontStyle: FontStyle.italic)),
          margin: EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
          backgroundColor: AppColor.snackbarBackground,
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }

    return true;
  }

  Future<void> saveTransaction() async {
    if (!(validateForm())) return;

    triggerLoading();
    Map<String, dynamic> body = {
      "transaction_date": isEdit
          ? DateFormat("yyyy-MM-dd").format(_transactionDate)
          : DateFormat("yyyy-MM-dd").format(DateTime.now()),
      "customer_id": _customer!.id,
      "total_price": _calculatedPrice,
      "fixed_price":
          double.tryParse(adjustedPriceText.text.replaceAll(".", "")) ?? 0,
      "discount_percentage":
          double.tryParse(discountPercentageText.text.replaceAll(".", "")) ?? 0,
      "discount_amount":
          double.tryParse(discountAmountText.text.replaceAll(".", "")) ?? 0,
      "outtown_charge":
          double.tryParse(outTownChargeText.text.replaceAll(".", "")) ?? 0,
      "additional_price":
          double.tryParse(additionalPriceText.text.replaceAll(".", "")) ?? 0,
      "grand_total": _finalPrice,
      "down_payment":
          double.tryParse(downPaymentText.text.replaceAll(".", "")) ?? 0,
      "total_paid": 0,
      "is_print": 0,
      "transactionProducts": _detailTransactionProducts
          .map((DetailTransactionProduct detailTransactionProduct) => {
                "product_id": detailTransactionProduct.product.id,
                "actual_rent_date": DateFormat("yyyy-MM-dd")
                    .format(detailTransactionProduct.rentDate),
                "rent_date": DateFormat("yyyy-MM-dd")
                    .format(detailTransactionProduct.rentDate),
                "return_date": DateFormat("yyyy-MM-dd")
                    .format(detailTransactionProduct.returnDate),
                "actual_return_date": DateFormat("yyyy-MM-dd")
                    .format(detailTransactionProduct.returnDate),
                "description": "Default Description",
              })
          .toList(),
      "transactionServices": _detailTransactionServices
          .map((DetailTransactionService detailTransactionService) => {
                "service_id": detailTransactionService.service.id,
                "description": "Default Description",
                "transactionServicesDates": [
                  {
                    "begin_date": DateFormat("yyyy-MM-dd")
                        .format(detailTransactionService.beginDate),
                    "end_date": DateFormat("yyyy-MM-dd")
                        .format(detailTransactionService.endDate),
                    "description": "Default Description",
                  },
                ]
              })
          .toList(),
    };

    if (_package != null) body["package_id"] = _package!.id;

    dynamic result;
    if (isEdit) {
      result =
          (await ApiService.me.put("transaction/${_id.toString()}", body)).body;
    } else {
      result = (await ApiService.me.post("transaction", body)).body;
    }

    triggerLoading();

    if (result != null) {
      Get.find<TransactionViewModel>().getTransactions(page: 1);
      Get.back();
      SmartDialog.showLoading(msg: "Loading...");
      // if (isEdit) {
      // await printPdf(transaction!);
      // } else {
      // await printPdf(result["data"]["id"].toString());
      // }
      SmartDialog.dismiss();
    }
  }

  // Future<void> printPdf(String id) async {
  //   triggerLoading();

  //   Response rs = await Dio().get(
  //     "${ApiService.me.baseUrl}api/transaction/export-pdf/$id",
  //     options: Options(
  //       headers: {
  //         "Authorization": "Bearer " + GlobalController.instance.activeUser!.token,
  //         Headers.acceptHeader: "application/json",
  //       },
  //       responseType: ResponseType.bytes,
  //     ),
  //   );

  //   await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => rs.data);
  // }

  Future<void> printPdf(Transaction transaction) async {
    pw.Document pdf = pw.Document();
    String backgroundSvg =
        await rootBundle.loadString("assets/images/invoice-background.svg");
    pdf.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          pageFormat: PdfPageFormat.a4,
          theme: pw.ThemeData.base(),
          buildBackground: (pw.Context context) {
            return pw.FullPage(
              ignoreMargins: true,
              child: pw.SvgImage(
                svg: backgroundSvg,
                fit: pw.BoxFit.cover,
              ),
            );
          },
        ),
        footer: (pw.Context context) {
          return pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Flexible(
                flex: 1,
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Text("Instagram : ",
                        style: pw.TextStyle(
                            fontSize: 8, fontWeight: pw.FontWeight.bold)),
                    pw.Text("$instagram", style: pw.TextStyle(fontSize: 8)),
                  ],
                ),
              ),
              // pw.Flexible(
              //   flex: 1,
              //   child: pw.Row(
              //     mainAxisAlignment: pw.MainAxisAlignment.center,
              //     children: [
              //       pw.Text("Facebook : ", style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
              //       pw.Text("$facebook", style: pw.TextStyle(fontSize: 8)),
              //     ],
              //   ),
              // ),
              pw.Flexible(
                flex: 1,
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Text("Whatsapp : ",
                        style: pw.TextStyle(
                            fontSize: 8, fontWeight: pw.FontWeight.bold)),
                    pw.Text("$whatsapp", style: pw.TextStyle(fontSize: 8)),
                  ],
                ),
              ),
            ],
          );
        },
        build: (pw.Context context) {
          return [
            pw.Row(
              children: [
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text("Fairy Dust Bridal",
                          style: pw.TextStyle(
                              fontSize: 18, fontWeight: pw.FontWeight.bold)),
                      pw.Text(
                          "Jl. Urai Bawadi No.76A, Sungai Bangkong, Kec. Pontianak Kota, Kota Pontianak",
                          style: pw.TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                pw.Expanded(child: pw.Container()),
              ],
            ),
            pw.SizedBox(height: 30),
            pw.Row(
              children: [
                pw.Flexible(
                  flex: 2,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text("To : ", style: pw.TextStyle(fontSize: 14)),
                      pw.Text(transaction.customer.name.toUpperCase(),
                          style: pw.TextStyle(
                              fontSize: 16, fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(height: 5),
                      pw.Row(
                        children: [
                          pw.Expanded(
                              child: pw.Container(
                                  color: PdfColors.teal, height: 2.5)),
                          pw.Expanded(child: pw.Container()),
                        ],
                      ),
                      pw.SizedBox(height: 5),
                      pw.Text("P : ${transaction.customer.phoneNumber ?? "-"}",
                          style: pw.TextStyle(fontSize: 12)),
                      pw.Text("E : ${transaction.customer.email ?? "-"}",
                          style: pw.TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                pw.Flexible(
                  flex: 1,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text("INVOICE",
                          style: pw.TextStyle(
                              color: PdfColors.teal,
                              fontSize: 18,
                              fontWeight: pw.FontWeight.bold)),
                      pw.Text("Invoice-${transaction.id}",
                          style: pw.TextStyle(fontSize: 12)),
                      pw.Text(
                          "Date : ${DateFormat("dd MMM yyyy").format(transaction.transactionDate)}",
                          style: pw.TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Text("Package : ", style: pw.TextStyle(fontSize: 12)),
            pw.SizedBox(height: 5),
            pw.Text(transaction.package?.name ?? "-",
                style:
                    pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 20),
            pw.Text("Items : ", style: pw.TextStyle(fontSize: 12)),
            pw.SizedBox(height: 5),
            pw.Table.fromTextArray(
              border: pw.TableBorder.symmetric(
                inside: pw.BorderSide(),
              ),
              cellAlignment: pw.Alignment.centerLeft,
              headerDecoration:
                  pw.BoxDecoration(color: PdfColor.fromHex("#060632")),
              headerHeight: 30,
              cellHeight: 30,
              cellAlignments: {
                0: pw.Alignment.center,
                1: pw.Alignment.centerLeft,
              },
              cellPadding: pw.EdgeInsets.symmetric(horizontal: 10),
              columnWidths: {
                0: pw.FixedColumnWidth(10),
                1: pw.IntrinsicColumnWidth(),
              },
              headerStyle: pw.TextStyle(
                  color: PdfColors.white,
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold),
              rowDecoration:
                  pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide())),
              cellStyle:
                  const pw.TextStyle(color: PdfColors.black, fontSize: 10),
              headers: List<String>.generate(
                  2, (col) => ['No.', 'Item Description'][col]),
              data: List<List<String>>.generate(
                transaction.transactionProducts.length +
                    transaction.transactionServices.length,
                (row) => List<String>.generate(2, (col) {
                  if (col == 0) return "${row + 1}";

                  if (row < transaction.transactionProducts.length)
                    return "${transaction.transactionProducts[row].product.type.name} ${transaction.transactionProducts[row].product.category.name}";
                  return "${transaction.transactionServices[row - transaction.transactionProducts.length].service.description}";
                }),
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Flexible(
                  flex: 5,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text("PAYMENT METHOD",
                          style: pw.TextStyle(
                              color: PdfColors.teal,
                              fontSize: 14,
                              fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(height: 10),
                      pw.Text("Bank BCA 0292162071",
                          style: pw.TextStyle(
                              fontSize: 12, fontWeight: pw.FontWeight.bold)),
                      pw.Text("a.n. ANGEL", style: pw.TextStyle(fontSize: 12)),
                      pw.SizedBox(height: 10),
                      pw.Text("Bank BNI 1111050584",
                          style: pw.TextStyle(
                              fontSize: 12, fontWeight: pw.FontWeight.bold)),
                      pw.Text("a.n. ANGEL", style: pw.TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                pw.Flexible(
                  flex: 4,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text("Total Price",
                              style: pw.TextStyle(fontSize: 14)),
                          pw.Text(
                              "Rp ${NumberFormat("#,###").format(transaction.adjustedPrice)}",
                              style: pw.TextStyle(fontSize: 14),
                              textAlign: pw.TextAlign.right),
                        ],
                      ),
                      pw.SizedBox(height: 5),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text("Discount (%)",
                              style: pw.TextStyle(fontSize: 14)),
                          pw.Text("${transaction.discountPercentage}%",
                              style: pw.TextStyle(fontSize: 14),
                              textAlign: pw.TextAlign.right),
                        ],
                      ),
                      pw.SizedBox(height: 5),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text("Discount (Rp)",
                              style: pw.TextStyle(fontSize: 14)),
                          pw.Text(
                              "Rp ${NumberFormat("#,###").format(transaction.discountAmount)}",
                              style: pw.TextStyle(fontSize: 14),
                              textAlign: pw.TextAlign.right),
                        ],
                      ),
                      pw.SizedBox(height: 5),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text("Outtown Charge",
                              style: pw.TextStyle(fontSize: 14)),
                          pw.Text(
                              "Rp ${NumberFormat("#,###").format(transaction.outTownCharge)}",
                              style: pw.TextStyle(fontSize: 14),
                              textAlign: pw.TextAlign.right),
                        ],
                      ),
                      pw.SizedBox(height: 5),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text("Additional Price",
                              style: pw.TextStyle(fontSize: 14)),
                          pw.Text(
                              "Rp ${NumberFormat("#,###").format(transaction.additionalPrice)}",
                              style: pw.TextStyle(fontSize: 14),
                              textAlign: pw.TextAlign.right),
                        ],
                      ),
                      pw.SizedBox(height: 10),
                      pw.Container(
                          color: PdfColors.teal,
                          height: 2.5,
                          width: double.infinity),
                      pw.SizedBox(height: 10),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text("Down Payment",
                              style: pw.TextStyle(fontSize: 14)),
                          pw.Text(
                              "Rp ${NumberFormat("#,###").format(transaction.downPayment)}",
                              style: pw.TextStyle(fontSize: 14),
                              textAlign: pw.TextAlign.right),
                        ],
                      ),
                      pw.SizedBox(height: 10),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Container(
                            color: PdfColor.fromHex("#060632"),
                            padding: pw.EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: pw.Text("TOTAL",
                                style: pw.TextStyle(
                                    color: PdfColors.white,
                                    fontSize: 16,
                                    fontWeight: pw.FontWeight.bold)),
                          ),
                          pw.Expanded(
                            child: pw.Container(
                              color: PdfColors.teal,
                              padding: pw.EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: pw.Text(
                                  "Rp ${NumberFormat("#,###").format(transaction.grandTotal)}",
                                  style: pw.TextStyle(
                                      color: PdfColors.white,
                                      fontSize: 16,
                                      fontWeight: pw.FontWeight.bold),
                                  textAlign: pw.TextAlign.right),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ];
        },
      ),
    ); // Page

    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save());
  }
}
