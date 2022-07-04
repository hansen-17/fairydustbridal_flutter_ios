import 'photo.dart';

class Customer {
  String id;
  String name;
  String? phoneNumber;
  String? email;
  String? instagram;
  Photo? idCardPhoto;

  Customer({
    required this.id,
    required this.name,
    required this.phoneNumber,
    this.email,
    this.instagram,
    this.idCardPhoto,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json["id"],
      name: json["name"],
      phoneNumber: json["[phone_number]"] != "" ? json["[phone_number]"] : null,
      email: json["email"] != "" ? json["email"] : null,
      instagram: json["instagram"] != "" ? json["instagram"] : null,
      idCardPhoto: json["image"] != null ? Photo.fromString(json["image"]) : null,
    );
  }
}
