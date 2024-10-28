import 'package:cli_shared/src/models/utils.dart';

class Item with Identifiable {
  String description;

  @override
  Id id;

  Item({required this.description, Id? id}) : id = id ?? Id.unique();

  factory Item.fromJson(Map<String, dynamic> json) {
    if (json case {"description": String description, "id": Id id}) {
      return Item(description: description, id: id);
    } else {
      throw Exception("Invalid JSON");
    }
  }

  Map<String, dynamic> toJson() {
    // use record / object destructuring instead

    return {"description": description, "id": id};
  }
}
