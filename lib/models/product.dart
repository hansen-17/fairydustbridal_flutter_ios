import 'photo.dart';

class Product {
  String id;
  String code;
  double price;
  ProductCategory category;
  ProductType type;
  List<Photo> photos;

  Product({
    required this.id,
    required this.code,
    this.price = 0,
    required this.category,
    required this.type,
    this.photos = const [],
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json["id"],
      code: json["code"],
      price: json["price"].toDouble(),
      category: ProductCategory.fromJson(json["category"]),
      type: ProductType.fromJson(json["type"]),
      photos: json["photos"].map<Photo>((photoJson) => Photo.fromJson(photoJson)).toList(),
    );
  }
}

class ProductCategory {
  String id;
  String name;

  ProductCategory({
    required this.id,
    required this.name,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      id: json["id"],
      name: json["name"],
    );
  }
}

class ProductType {
  String id;
  String name;

  ProductType({
    required this.id,
    required this.name,
  });

  factory ProductType.fromJson(Map<String, dynamic> json) {
    return ProductType(
      id: json["id"],
      name: json["name"],
    );
  }
}
