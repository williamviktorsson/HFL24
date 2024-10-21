class Item {
  final String description;
  final int id;

  Item(this.description, [this.id = -1]);

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(json['description'], json['id']);
  }

  Map<String, dynamic> toJson() {
    return {"description": description, "id": id};
  }
}

// vad vi vill ha på klienten
class Bag {
  final String description;
  final List<Item> items;



  Bag({required this.description, required this.items});
}
