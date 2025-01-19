import 'package:server/router_config.dart';
import 'package:shared/only_import_on_storage_device.dart';
import 'package:shared/shared.dart';

class BagRepository implements RepositoryInterface<Bag> {
  Box<Bag> bagBox = ServerConfig.instance.store.box<Bag>();

  @override
  Future<Bag> create(Bag bag) async {
    bagBox.put(bag, mode: PutMode.insert);

    // firebase API call store in collection "bags" asdgasud hagsjdgashjdgajshdgasjhdgasjhdjasghdsajhjahsgdasjhgdagjshjhasjhgajshgd
    // use HTTP API

    // above command did not error
    return bag;
  }

  @override
  Future<Bag?> getById(int id) async {
    return bagBox.get(id);      
  }

  @override
  Future<List<Bag>> getAll() async {
    return bagBox.getAll();
  }

  @override
  Future<Bag> update(int id, Bag newBag) async {
    bagBox.put(newBag, mode: PutMode.update);
    return newBag;
  }

  @override
  Future<Bag?> delete(int id) async {
    Bag? bag = bagBox.get(id);

    if (bag != null) {
      bagBox.remove(id);
    }

    return bag;
  }
}
