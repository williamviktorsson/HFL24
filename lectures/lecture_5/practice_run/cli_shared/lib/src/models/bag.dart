import 'package:cli_shared/src/models/utils.dart';

import 'item.dart';

class Brand with Identifiable {
  @override
  Id id;
  String name;
  Brand({required this.name, Id? id}) : id = id ?? Id.unique();

  factory Brand.fromJson(Map<String, dynamic> json) {
    if (json case {"name": String name, "id": Id id}) {
      return Brand(name: name, id: id);
    } else {
      throw Exception("Invalid JSON");
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "id": id,
    };
  }
}

class Bag with Identifiable {
  String description;

  List<Item> items;

  Brand
      brand; // make nullable because we cant assign it in the constructor when creating from database

  @override
  Id id;

  Bag(
      {required this.description,
      this.items = const [],
      required this.brand,
      Id? id})
      : id = id ?? Id.unique();

  factory Bag.fromJson(Map<String, dynamic> json) {
    if (json
        case {
          "description": String description,
          "id": Id id,
          "items": List<Map<String, dynamic>> items,
          "brand": Map<String, dynamic> brand
        }) {
      return Bag(
          description: description,
          id: id,
          items: items.map((json) => Item.fromJson(json)).toList(),
          brand: Brand.fromJson(brand));
    } else {
      throw Exception("Invalid JSON");
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "description": description,
      "id": id,
      'items': items.map((item) => item.toJson()).toList(),
      'brand': brand.toJson()
    };
  }
}
