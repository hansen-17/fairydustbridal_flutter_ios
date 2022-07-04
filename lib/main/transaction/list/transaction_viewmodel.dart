import 'dart:core';

import 'package:flutter/services.dart';
import 'package:get/get.dart' hide Response;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../models/customer.dart';
import '../../../models/transaction.dart';
import '../../../utils/api_service.dart';

enum DisplayType { TODAY, PAST }

class TransactionViewModel extends GetxController {
  DateTime _selectedDay = DateTime.now();
  DateTime get selectedDay => _selectedDay;
  int get numberOfDays => DateTime(selectedDay.year, selectedDay.month + 1, 0).day;
  void setSelectedDay(DateTime date) {
    _selectedDay = DateTime(date.year, date.month, date.day);
    _currentTransactionPage = 1;
    getTransactions();
    update();
  }

  DisplayType _selectedDisplay = DisplayType.TODAY;
  DisplayType get selectedDisplay => _selectedDisplay;
  void toggleDisplayTo(DisplayType displayType) {
    if (_selectedDisplay == displayType) return;
    _currentTransactionPage = 1;
    _selectedDisplay = displayType;
    getTransactions();
    update();
  }

  bool _loading = false;
  bool get isLoading => _loading;
  void triggerLoading() {
    _loading = !_loading;
    update();
  }

  List<Transaction> _transactions = [];
  List<Transaction> get transactions => _transactions;

  int _currentTransactionPage = 1;
  int _totalTransactionPage = 1;

  @override
  void onInit() async {
    super.onInit();
    getTransactions();
    loadAbout();
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

  Future<void> getTransactions({int page = 1}) async {
    if (page == 1) _transactions.clear();
    Map<String, dynamic> query = {
      "limit": "10",
      "page": "$page",
    };

    if (_selectedDisplay == DisplayType.TODAY) {
      query["transaction_date"] = DateFormat("yyyy-MM-dd").format(_selectedDay);
    } else {
      query["date"] = DateFormat("yyyy-MM-dd").format(_selectedDay);
    }

    if (page == 1) triggerLoading();
    if (page != 1) insertLoadingCard();

    dynamic result = (await ApiService.me.get("transaction", query: query)).body;

    if (page == 1) triggerLoading();
    if (page != 1) removeLoadingCard();

    if (result != null) {
      dynamic data = result["data"]["data"];
      data.forEach((datum) {
        _transactions.add(Transaction.fromJson(datum));
      });
      _currentTransactionPage = result["data"]["current_page"];
      _totalTransactionPage = result["data"]["last_page"];
    }

    update();
  }

  Future<void> loadMoreTransactions() async {
    if (_currentTransactionPage == _totalTransactionPage) return;

    _currentTransactionPage += 1;
    await getTransactions(page: _currentTransactionPage);
  }

  void insertLoadingCard() {
    _transactions.add(Transaction(id: 0, transactionDate: DateTime.now(), customer: Customer(id: "", name: "", phoneNumber: "")));
    update();
  }

  void removeLoadingCard() {
    _transactions.removeWhere((Transaction transaction) => transaction.id == 0);
    update();
  }

  Future<void> deleteTransaction(Transaction transaction) async {
    triggerLoading();
    dynamic result = (await ApiService.me.delete("transaction/${transaction.id}")).body;
    triggerLoading();

    if (result != null) {
      _transactions.remove(transaction);
    }

    update();
  }

  // Future<void> printPdf(String id) async {
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
    String backgroundSvg = await rootBundle.loadString("assets/images/invoice-background.svg");
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
                    pw.Text("Instagram : ", style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
                    pw.Text("$instagram", style: pw.TextStyle(fontSize: 8)),
                  ],
                ),
              ),
              pw.Flexible(
                flex: 1,
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Text("Facebook : ", style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
                    pw.Text("$facebook", style: pw.TextStyle(fontSize: 8)),
                  ],
                ),
              ),
              pw.Flexible(
                flex: 1,
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Text("Whatsapp : ", style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
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
                      pw.Text("Fairy Dust Bridal", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                      pw.Text("Jl. Urai Bawadi No.76A, Sungai Bangkong, Kec. Pontianak Kota, Kota Pontianak", style: pw.TextStyle(fontSize: 12)),
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
                      pw.Text(transaction.customer.name.toUpperCase(), style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(height: 5),
                      pw.Row(
                        children: [
                          pw.Expanded(child: pw.Container(color: PdfColors.teal, height: 2.5)),
                          pw.Expanded(child: pw.Container()),
                        ],
                      ),
                      pw.SizedBox(height: 5),
                      pw.Text("P : ${transaction.customer.phoneNumber ?? "-"}", style: pw.TextStyle(fontSize: 12)),
                      pw.Text("E : ${transaction.customer.email ?? "-"}", style: pw.TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                pw.Flexible(
                  flex: 1,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text("INVOICE", style: pw.TextStyle(color: PdfColors.teal, fontSize: 18, fontWeight: pw.FontWeight.bold)),
                      pw.Text("Invoice-${transaction.id}", style: pw.TextStyle(fontSize: 12)),
                      pw.Text("Date : ${DateFormat("dd MMM yyyy").format(transaction.transactionDate)}", style: pw.TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Text("Package : ", style: pw.TextStyle(fontSize: 12)),
            pw.SizedBox(height: 5),
            pw.Text(transaction.package?.name ?? "-", style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 20),
            pw.Text("Items : ", style: pw.TextStyle(fontSize: 12)),
            pw.SizedBox(height: 5),
            pw.Table.fromTextArray(
              border: pw.TableBorder.symmetric(
                inside: pw.BorderSide(),
              ),
              cellAlignment: pw.Alignment.centerLeft,
              headerDecoration: pw.BoxDecoration(color: PdfColor.fromHex("#060632")),
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
              headerStyle: pw.TextStyle(color: PdfColors.white, fontSize: 10, fontWeight: pw.FontWeight.bold),
              rowDecoration: pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide())),
              cellStyle: const pw.TextStyle(color: PdfColors.black, fontSize: 10),
              headers: List<String>.generate(2, (col) => ['No.', 'Item Description'][col]),
              data: List<List<String>>.generate(
                transaction.transactionProducts.length + transaction.transactionServices.length,
                (row) => List<String>.generate(2, (col) {
                  if (col == 0) return "${row + 1}";

                  if (row < transaction.transactionProducts.length) return "${transaction.transactionProducts[row].product.type.name} ${transaction.transactionProducts[row].product.category.name}";
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
                      pw.Text("PAYMENT METHOD", style: pw.TextStyle(color: PdfColors.teal, fontSize: 14, fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(height: 10),
                      pw.Text("Bank BCA 1234567890", style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                      pw.Text("a.n. Angel O' Brien", style: pw.TextStyle(fontSize: 12)),
                      pw.SizedBox(height: 10),
                      pw.Text("Bank Mandiri 1234567890", style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                      pw.Text("a.n. Angel O' Brien", style: pw.TextStyle(fontSize: 12)),
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
                          pw.Text("Total Price", style: pw.TextStyle(fontSize: 14)),
                          pw.Text("Rp ${NumberFormat("#,###").format(transaction.adjustedPrice)}", style: pw.TextStyle(fontSize: 14), textAlign: pw.TextAlign.right),
                        ],
                      ),
                      pw.SizedBox(height: 5),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text("Discount (%)", style: pw.TextStyle(fontSize: 14)),
                          pw.Text("${transaction.discountPercentage}%", style: pw.TextStyle(fontSize: 14), textAlign: pw.TextAlign.right),
                        ],
                      ),
                      pw.SizedBox(height: 5),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text("Discount (Rp)", style: pw.TextStyle(fontSize: 14)),
                          pw.Text("Rp ${NumberFormat("#,###").format(transaction.discountAmount)}", style: pw.TextStyle(fontSize: 14), textAlign: pw.TextAlign.right),
                        ],
                      ),
                      pw.SizedBox(height: 5),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text("Outtown Charge", style: pw.TextStyle(fontSize: 14)),
                          pw.Text("Rp ${NumberFormat("#,###").format(transaction.outTownCharge)}", style: pw.TextStyle(fontSize: 14), textAlign: pw.TextAlign.right),
                        ],
                      ),
                      pw.SizedBox(height: 5),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text("Additional Price", style: pw.TextStyle(fontSize: 14)),
                          pw.Text("Rp ${NumberFormat("#,###").format(transaction.additionalPrice)}", style: pw.TextStyle(fontSize: 14), textAlign: pw.TextAlign.right),
                        ],
                      ),
                      pw.SizedBox(height: 10),
                      pw.Container(color: PdfColors.teal, height: 2.5, width: double.infinity),
                      pw.SizedBox(height: 10),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Container(
                            color: PdfColor.fromHex("#060632"),
                            padding: pw.EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            child: pw.Text("TOTAL", style: pw.TextStyle(color: PdfColors.white, fontSize: 16, fontWeight: pw.FontWeight.bold)),
                          ),
                          pw.Expanded(
                            child: pw.Container(
                              color: PdfColors.teal,
                              padding: pw.EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              child: pw.Text("Rp ${NumberFormat("#,###").format(transaction.grandTotal)}", style: pw.TextStyle(color: PdfColors.white, fontSize: 16, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.right),
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

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }
}
