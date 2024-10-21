import 'dart:io';

import 'package:cli_server/handlers/bag_handlers.dart';
import 'package:cli_server/handlers/item_handlers.dart';
import 'package:cli_shared/cli_shared.dart';
import 'package:shelf_router/shelf_router.dart';

class ServerConfig {
  // make singleton

  ServerConfig._privateConstructor();

  static final ServerConfig _instance = ServerConfig._privateConstructor();

  static ServerConfig get instance => _instance;

  final store = openStore(directory: '${Directory.current.path}/store');

  Router initialize() {
    // Configure routes.
    final router = Router();

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

    return router;
  }

  teardown() {
    store.close();
  }
}
