import 'package:uuid/uuid.dart';

class Item {
  String description;
  String id;
  String creatorId;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Item && other.description == description && other.id == id && other.creatorId == creatorId;
  }

  @override
  int get hashCode => description.hashCode ^ id.hashCode ^ creatorId.hashCode;

  Item({required this.description, required this.creatorId, String? id}) : id = id ?? Uuid().v4();

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(description: json['description'], creatorId: json['creatorId'], id: json['id']);
  }

  Map<String, dynamic> toJson() {
    return {"description": description, "creatorId": creatorId, "id": id};
  }
}
