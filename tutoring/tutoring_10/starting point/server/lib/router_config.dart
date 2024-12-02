import 'package:server/handlers/bag_handlers.dart';
import 'package:server/handlers/item_handlers.dart';
import 'package:shared/only_import_on_storage_device.dart';
import 'package:shelf_router/shelf_router.dart';


class ServerConfig {
  // singleton constructor

  ServerConfig._privateConstructor() {
    initializer();
  }

  static final ServerConfig _instance = ServerConfig._privateConstructor();

  static ServerConfig get instance => _instance;

  late Store store;

  late Router router;

  initializer() {
    // Configure routes.
    router = Router();

    store = openStore();

    // check content
    // if that which you want to fill it with doesnt exist
    // fill it

    

    router.post('/items', postItemHandler); // create an item
    router.get('/items', getItemsHandler); // get all items
    router.get('/items/<id>', getItemHandler); // get specific item
    router.put('/items/<id>', updateItemHandler); // update specific item
    router.delete('/items/<id>', deleteItemHandler); // update specific item

    router.post('/bags', postBagHandler); // create a bag
    router.get('/bags', getBagsHandler); // get all bags
    router.get('/bags/<id>', getBagHandler); // get specific bag
    router.put('/bags/<id>', updateBagHandler); // update specific bag
    router.delete('/bags/<id>', deleteBagHandler); // update specific bag
  }
}
