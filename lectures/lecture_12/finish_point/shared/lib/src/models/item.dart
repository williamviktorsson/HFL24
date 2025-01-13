import 'package:uuid/uuid.dart';

class Item {
  String description;

  String id;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Item && other.description == description;
  }

  @override
  int get hashCode => description.hashCode;

  Item(this.description, [String? id]) : id = id ?? Uuid().v4();

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(json['description'], json['id']);
  }

  Map<String, dynamic> toJson() {
    return {"description": description, "id": id};
  }
}
