class User {
  late String id;
  String name;
  String token;
  String? email;
  bool isEmailVerified;

  User({
    required this.name,
    required this.token,
    this.email,
    this.isEmailVerified = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json["name"],
      token: json["access_token"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "access_token": token,
    };
  }
}
