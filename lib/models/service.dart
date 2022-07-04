import 'photo.dart';

class Service {
  String id;
  String description;
  double price;
  ServiceType? type;
  Photo? photo;

  Service({
    required this.id,
    required this.description,
    required this.price,
    this.type,
    this.photo,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json["id"],
      description: json["description"],
      price: json["price"].toDouble(),
      type: json["type"] != null ? ServiceType.fromJson(json["type"]) : null,
      photo: json["image"] != "" ? Photo.fromString(json["image"]) : null,
    );
  }
}

class ServiceType {
  String id;
  String name;

  ServiceType({
    required this.id,
    required this.name,
  });

  factory ServiceType.fromJson(Map<String, dynamic> json) {
    return ServiceType(
      id: json["id"],
      name: json["name"],
    );
  }
}
