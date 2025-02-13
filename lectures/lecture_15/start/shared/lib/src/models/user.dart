import 'package:uuid/uuid.dart';

class User {
  String email;
  String username;
  String id;
  String
      authId; // possible to skip the authId reference and just assign the same id to the id of the user.

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.email == email &&
        other.id == id &&
        other.authId == authId;
  }

  @override
  int get hashCode => email.hashCode ^ id.hashCode ^ authId.hashCode;

  User(
      {required this.email,
      required this.authId,
      required this.username,
      String? id})
      : id = id ?? Uuid().v4();

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      authId: json["authId"],
      id: json['id'],
      username: json['username'],
    );
  }

  Map<String, dynamic> toJson() {
    return {"email": email, "id": id, "authId": authId, "username": username};
  }
}
