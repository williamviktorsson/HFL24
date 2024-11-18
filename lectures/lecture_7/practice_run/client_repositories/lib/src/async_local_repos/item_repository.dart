import 'package:shared/shared.dart';

class ItemRepository implements RepositoryInterface<Item> {
  final List<Item> _items = [
    Item("Book", 0),
    Item("Robe", 1),
    Item("Ford Anglia keys", 2)
  ];

  late int itemIds;

  // singleton

  ItemRepository._internal() {
    itemIds = _items.length;
  }

  static final ItemRepository _instance = ItemRepository._internal();

  static ItemRepository get instance => _instance;

  @override
  Future<Item> create(Item item) async {
    if (item.id < 0) {
      item.id = itemIds++;
    }
    _items.add(item);
    return item;
  }

  @override
  Future<Item> getById(int id) async {
    return _items.firstWhere((e) => e.id == id);
  }

  @override
  Future<List<Item>> getAll() async => List.from(_items);

  @override
  Future<Item> update(int id, Item newItem) async {
    var index = _items.indexWhere((e) => e.id == id);
    if (index >= 0 && index < _items.length) {
      _items[index] = newItem;
      return newItem;
    }
    throw RangeError.index(index, _items);
  }

  @override
  Future<Item> delete(int id) async {
    var index = _items.indexWhere((e) => e.id == id);
    if (index >= 0 && index < _items.length) {
      return _items.removeAt(index);
    }
    throw RangeError.index(index, _items);
  }
}
