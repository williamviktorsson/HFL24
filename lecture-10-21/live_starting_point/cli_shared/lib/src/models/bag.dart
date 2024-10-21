import 'item.dart';

class Bag {
  String description;
  List<Item> items;
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