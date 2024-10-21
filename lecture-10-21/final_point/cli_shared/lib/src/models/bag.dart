import 'dart:convert';
import 'dart:math';

import 'item.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Bag {
  String description;

  @Transient() // cant be stored in the database
  List<Item> items;

  // this actually is pretty magic.
  String get dbItems => jsonEncode(items.map((e) => e.toJson()).toList());
  set dbItems(String items) {
    this.items =
        (jsonDecode(items) as List).map((json) => Item.fromJson(json)).toList();
  }

  @Id()
  int id;

  Bag({required this.description, this.items = const [], this.id = -1});

  factory Bag.fromJson(Map<String, dynamic> json) {
    return Bag(
      description: json['description'],
      id: json['id'],
      items:
          (json['items'] as List).map((json) => Item.fromJson(json)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "description": description,
      "id": id,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}
