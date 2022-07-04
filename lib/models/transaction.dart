import 'package:intl/intl.dart';

import 'customer.dart';
import 'package.dart';
import 'product.dart';
import 'service.dart';

class Transaction {
  int id;
  DateTime transactionDate;
  Customer customer;
  Package? package;
  double calculatedPrice;
  double adjustedPrice;
  double discountPercentage;
  double discountAmount;
  double outTownCharge;
  double additionalPrice;
  double grandTotal;
  double downPayment;
  double totalPaid;
  bool isPrint;
  List<DetailTransactionProduct> transactionProducts;
  List<DetailTransactionService> transactionServices;

  int get totalItems => transactionProducts.length + transactionServices.length;
  String get firstPhotoUrl {
    if (transactionProducts.length > 0)
      return transactionProducts[0].product.photos[0].photoUrl;
    return transactionServices[0].service.photo!.photoUrl;
  }

  String get firstItemName {
    if (transactionProducts.length > 0)
      return "${transactionProducts[0].product.type.name} (${transactionProducts[0].product.code})";
    return transactionServices[0].service.description;
  }

  String get firstDates {
    if (transactionProducts.length > 0)
      return "${DateFormat("dd MMM yyyy").format(transactionProducts[0].rentDate)} - (${DateFormat("dd MMM yyyy").format(transactionProducts[0].returnDate)})";
    return "${DateFormat("dd MMM yyyy").format(transactionServices[0].beginDate)} - (${DateFormat("dd MMM yyyy").format(transactionServices[0].endDate)})";
  }

  Transaction({
    required this.id,
    required this.transactionDate,
    required this.customer,
    this.package,
    this.calculatedPrice = 0,
    this.adjustedPrice = 0,
    this.discountPercentage = 0,
    this.discountAmount = 0,
    this.outTownCharge = 0,
    this.additionalPrice = 0,
    this.grandTotal = 0,
    this.downPayment = 0,
    this.totalPaid = 0,
    this.isPrint = false,
    this.transactionProducts = const [],
    this.transactionServices = const [],
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json["id"],
      transactionDate: DateTime.parse(json["transaction_date"]),
      customer: Customer.fromJson(json["customer"]),
      package:
          json["package"] == null ? null : Package.fromJson(json["package"]),
      calculatedPrice: json["total_price"].toDouble(),
      adjustedPrice: json["fixed_price"].toDouble(),
      discountPercentage: json["discount_percentage"].toDouble(),
      discountAmount: json["discount_amount"].toDouble(),
      outTownCharge: json["outtown_charge"].toDouble(),
      additionalPrice: json["additional_price"].toDouble(),
      grandTotal: json["grand_total"].toDouble(),
      downPayment: json["down_payment"].toDouble(),
      totalPaid: json["total_paid"].toDouble(),
      isPrint: json["is_print"] == 1,
      transactionProducts: json["transaction_products"]
          .map<DetailTransactionProduct>(
              (dynamic map) => DetailTransactionProduct.fromJson(map))
          .toList(),
      transactionServices: json["transaction_services"]
          .map<DetailTransactionService>(
              (dynamic map) => DetailTransactionService.fromJson(map))
          .toList(),
    );
  }
}

class DetailTransactionProduct {
  String id;
  Product product;
  DateTime? actualRentDate;
  DateTime rentDate;
  DateTime returnDate;
  DateTime? actualReturnDate;
  String? description;

  DetailTransactionProduct({
    required this.id,
    required this.product,
    this.actualRentDate,
    required this.rentDate,
    required this.returnDate,
    this.actualReturnDate,
    this.description = "",
  });

  factory DetailTransactionProduct.fromJson(Map<String, dynamic> json) {
    return DetailTransactionProduct(
      id: json["id"],
      product: Product.fromJson(json["product"]),
      actualRentDate: DateTime.parse(json["actual_rent_date"]),
      rentDate: DateTime.parse(json["rent_date"]),
      returnDate: DateTime.parse(json["return_date"]),
      actualReturnDate: DateTime.parse(json["actual_return_date"]),
      description: json["description"],
    );
  }
}

class DetailTransactionService {
  String id;
  Service service;
  DateTime beginDate;
  DateTime endDate;
  String? description;

  DetailTransactionService({
    required this.id,
    required this.service,
    required this.beginDate,
    required this.endDate,
    this.description = "",
  });

  factory DetailTransactionService.fromJson(Map<String, dynamic> json) {
    return DetailTransactionService(
      id: json["id"],
      service: Service.fromJson(json["service"]),
      beginDate: json["transaction_service_date"].isEmpty
          ? DateTime.now()
          : DateTime.parse(json["transaction_service_date"][0]["begin_date"]),
      endDate: json["transaction_service_date"].isEmpty
          ? DateTime.now()
          : DateTime.parse(json["transaction_service_date"][0]["end_date"]),
      description: json["description"],
    );
  }
}
