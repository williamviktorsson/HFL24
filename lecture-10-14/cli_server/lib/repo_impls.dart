part of 'repos.dart';

class ItemRepository extends Repository<Item> {
  @override
  final _items = [];

  @override
  void add(Item item) {
    _items.add(item);
  }
}

ItemRepository repository = ItemRepository();
