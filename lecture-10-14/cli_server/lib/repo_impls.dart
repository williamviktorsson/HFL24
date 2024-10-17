part of 'repos.dart';

class ItemRepository extends Repository<Item> {
  @override
  final _items = [];

  @override
  void add(Item item) {
    _items.add(item);
  }

  @override
  Item getById(int id) {
    return _items.firstWhere((e) => e.id == id);
  }

  @override
  void update(int id, Item newItem) {
    var index = _items.indexWhere((e) => e.id == id);
    if (index >= 0) {
      print(newItem.toJson());
      _items[index] = newItem;
    }
  }
}

ItemRepository repository = ItemRepository();
