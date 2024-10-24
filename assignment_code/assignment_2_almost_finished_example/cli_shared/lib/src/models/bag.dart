import 'dart:convert';

import 'package:objectbox/objectbox.dart';

import 'item.dart';

@Entity()
class Brand {
  @Id()
  int id;
  String name;
  Brand({required this.name, this.id = -1});

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      name: json['name'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "id": id,
    };
  }
}

@Entity()
class Bag {
  String description;

  @Transient()
  List<Item> items;

  @Transient() // set as transient because it cant be stored
  Brand?
      brand; // make nullable because we cant assign it in the constructor when creating from database

  @Id()
  int id;

  // getter to read items from database
  String get itemsInDb {
    return jsonEncode(items.map((item) => item.toJson()).toList());
  }

  // setter to save it in database
  set itemsInDb(String json) {
    items = (jsonDecode(json) as List)
        .map((json_item) => Item.fromJson(json_item))
        .toList();
  }

  // make getter to read brand as string from db
  String? get brandInDb {
    if (brand == null) {
      return null;
    } else {
      return jsonEncode(brand!.toJson());
    }
  }

  // make setter to store brand as string in db
  set brandInDb(String? json) {
    if (json == null) {
      brand = null;
      return;
    }

    var decoded = jsonDecode(json);

    if (decoded != null) {
      brand = Brand.fromJson(decoded);
    } else {
      brand = null;
    }
  }

  Bag({required this.description, List<Item>? items, this.id = -1, this.brand})
      : items = items ?? [];

  factory Bag.fromJson(Map<String, dynamic> json) {
    return Bag(
        description: json['description'],
        id: json['id'],
        items:
            (json['items'] as List).map((json) => Item.fromJson(json)).toList(),
        brand: json['brand'] != null ? Brand.fromJson(json['brand']) : null);
  }

  Map<String, dynamic> toJson() {
    return {
      "description": description,
      "id": id,
      'items': items.map((item) => item.toJson()).toList(),
      'brand': brand?.toJson()
    };
  }
}
