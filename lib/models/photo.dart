import '../utils/api_service.dart';

class Group {
  String id;
  String name;
  List<Photo> photos;

  Group({
    required this.id,
    required this.name,
    this.photos = const [],
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json["id"],
      name: json["name"],
      photos: json["photos"].map<Photo>((photoJson) => Photo.fromJson(photoJson)).toList(),
    );
  }
}

class Photo {
  String? id;
  String photoUrl;

  Photo({
    this.id,
    required this.photoUrl,
  });

  factory Photo.fromString(String url) {
    return Photo(
      photoUrl: ApiService.me.baseUrl + "storage/" + url,
    );
  }

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json["id"],
      photoUrl: ApiService.me.baseUrl + "storage/" + json["photo"],
    );
  }
}
