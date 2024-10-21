part 'repo_impls.dart';

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

abstract class Repository<T> {
  List<T> _items = [];

  void add(T item) {
    _items.add(item);
  }

  List<T> getAll() {
    return _items;
  }

  T getById(int id);

  void update(int id, T newItem);

  void delete(T item) {
    _items.remove(item);
  }
}
