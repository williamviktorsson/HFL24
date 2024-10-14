class Item {
  final String description;
  Item(this.description);

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(json['description']);
  }

  Map<String, dynamic> toJson() {
    return {"description": description};
  }
}
