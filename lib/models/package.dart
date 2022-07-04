import 'photo.dart';
import 'product.dart';
import 'service.dart';

class Package {
  String id;
  String name;
  Photo? photo;
  double price;
  List<PackageDetailProduct>? products;
  List<PackageDetailService>? services;

  List<dynamic> get allItems => [...products!, ...services!];

  Package({
    required this.id,
    required this.name,
    this.photo,
    required this.price,
    this.products = const [],
    this.services = const [],
  });

  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      id: json["id"],
      name: json["name"],
      photo: Photo.fromString(json["image"]),
      price: json["price"].toDouble(),
      products: json["package_products"] == null ? null : json["package_products"].map<PackageDetailProduct>((dynamic map) => PackageDetailProduct.fromJson(map)).toList(),
      services: json["package_services"] == null ? null : json["package_services"].map<PackageDetailService>((dynamic map) => PackageDetailService.fromJson(map)).toList(),
    );
  }
}

class PackageDetailProduct {
  ProductType type;
  ProductCategory category;
  double price;

  PackageDetailProduct({
    required this.type,
    required this.category,
    required this.price,
  });

  factory PackageDetailProduct.fromJson(Map<String, dynamic> json) {
    return PackageDetailProduct(
      type: ProductType.fromJson(json["type"]),
      category: ProductCategory.fromJson(json["category"]),
      price: json["price"].toDouble(),
    );
  }
}

class PackageDetailService {
  Service service;
  double price;

  PackageDetailService({
    required this.service,
    required this.price,
  });

  factory PackageDetailService.fromJson(Map<String, dynamic> json) {
    return PackageDetailService(
      service: Service.fromJson(json["service"]),
      price: json["price"].toDouble(),
    );
  }
}
