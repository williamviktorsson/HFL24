import 'package:cli_shared/src/models/extensions.dart';
import 'package:uuid/uuid.dart';

class Item with Identifiable {
  String description;

  Id id;

  Item(this.description, [Id? id]) : id = id ?? Id.unique();

  factory Item.fromJson(Map<String, dynamic> json) {
    if (json case {"description": String description, "id": Id id}) {
      return Item(description, id);
    } else {
      throw Exception("Missing json properties");
    }
  }

  Map<String, dynamic> toJson() {
    return {"description": description, "id": id};
  }

  @override
  bool operator ==(Object other) {
    return other is Item && other.description == description;
  }
}
