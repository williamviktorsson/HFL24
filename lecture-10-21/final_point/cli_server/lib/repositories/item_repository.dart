import 'package:cli_server/router_config.dart';
import 'package:cli_shared/cli_shared.dart';

class ItemRepository implements RepositoryInterface<Item> {
  final itemBox = ServerConfig.instance.store.box<Item>();

  @override
  Future<Item?> create(Item item) async {
    itemBox.put(item, mode: PutMode.insert);
    return item;
  }

  @override
  Future<Item?> getById(int id) async {
    final user = itemBox.get(id);
    return user;
  }

  @override
  Future<List<Item>> getAll() async => itemBox.getAll();

  @override
  Future<Item?> update(int id, Item newItem) async {
    itemBox.put(newItem, mode: PutMode.update);
    return newItem;
  }

  @override
  Future<Item?> delete(int id) async {
    final item = itemBox.get(id);
    itemBox.remove(id);
    return item;
  }
}
