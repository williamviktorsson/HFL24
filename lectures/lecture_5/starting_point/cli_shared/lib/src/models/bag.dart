import 'package:cli_shared/src/models/extensions.dart';
import 'package:uuid/uuid.dart';

import 'item.dart';

class Brand with Identifiable {
  Id id;
  String name;
  Brand({required this.name, Id? id}) : id = id ?? Id.unique();

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

class Bag with Identifiable {
  String description;

  List<Item> items;

  Brand
      brand; // make nullable because we cant assign it in the constructor when creating from database

  Id id;

  Bag(
      {required this.description,
      this.items = const [],
      required this.brand,
      Id? id})
      : id = id ?? Id.unique();

  factory Bag.fromJson(Map<String, dynamic> json) {
    return Bag(
        description: json['description'],
        id: json['id'],
        items:
            (json['items'] as List).map((json) => Item.fromJson(json)).toList(),
        brand: Brand.fromJson(json['brand']));
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

void main(List<String> args) {
  List<Identifiable> things = [];

  
  things.add(Bag(description: "description", brand: Brand(name: "name")));
  things.add(Item("description"));

  print(Item("description",Id(id:"asd"))==Item("description",Id(id:"asd")));




}