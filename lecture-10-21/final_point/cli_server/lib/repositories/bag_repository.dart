import 'package:cli_server/router_config.dart';
import 'package:cli_shared/cli_shared.dart';

class BagRepository implements RepositoryInterface<Bag> {
  final bagBox = ServerConfig.instance.store.box<Bag>();

  @override
  Future<Bag?> create(Bag bag) async {
    bagBox.put(bag, mode: PutMode.insert);
    return bag;
  }

  @override
  Future<Bag?> getById(int id) async {
    final user = bagBox.get(id);
    return user;
  }

  @override
  Future<List<Bag>> getAll() async => bagBox.getAll();

  @override
  Future<Bag?> update(int id, Bag newBag) async {
    bagBox.put(newBag, mode: PutMode.update);
    return newBag;
  }

  @override
  Future<Bag?> delete(int id) async {
    final bag = bagBox.get(id);
    bagBox.remove(id);
    return bag;
  }
}
