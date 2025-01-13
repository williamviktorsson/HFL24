import 'package:objectbox/objectbox.dart';

@Entity()
class Item {
  String description;

  @Id()
  int id;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Item && other.description == description;
  }

  @override
  int get hashCode => description.hashCode;

  Item(this.description, [this.id = -1]);

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(json['description'], json['id']);
  }

  Map<String, dynamic> toJson() {
    return {"description": description, "id": id};
  }
}
