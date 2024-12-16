import 'dart:convert';

import 'package:server/repositories/item_repository.dart';
import 'package:shared/shared.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

ItemRepository repo = ItemRepository();

Future<Response> postItemHandler(Request request) async {
  final data = await request.readAsString();
  final json = jsonDecode(data);
  var item = Item.fromJson(json);

  var item1 = Item("asd");
  var item2 = Item("asd");
  var item3 = Item("asd");
  var item4 = Item("asd");

  await repo.create(item1);
  await repo.create(item2);
  await repo.create(item3);
  await repo.create(item4);

  item = await repo.create(item);

  return Response.ok(
    jsonEncode(item),
    headers: {'Content-Type': 'application/json'},
  );
}

Future<Response> getItemsHandler(Request request) async {
  final items = await repo.getAll();

  final payload = items.map((e) => e.toJson()).toList();

  return Response.ok(
    jsonEncode(payload),
    headers: {'Content-Type': 'application/json'},
  );
}

Future<Response> getItemHandler(Request request) async {
  String? idStr = request.params["id"];

  if (idStr != null) {
    int? id = int.tryParse(idStr);

    if (id != null) {
      Item? item = await repo.getById(id);
      return Response.ok(
        jsonEncode(item),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  // do better handling
  return Response.badRequest();
}

Future<Response> updateItemHandler(Request request) async {
  String? idStr = request.params["id"];

  if (idStr != null) {
    int? id = int.tryParse(idStr);

    if (id != null) {
      final data = await request.readAsString();
      final json = jsonDecode(data);
      var item = Item.fromJson(json);
      item = await repo.update(id, item);
      return Response.ok(
        jsonEncode(item),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  // TODO: do better handling
  return Response.badRequest();
}

Future<Response> deleteItemHandler(Request request) async {
  String? id_str = request.params["id"];

  if (id_str != null) {
    int? id = int.tryParse(id_str);

    if (id != null) {
      Item? item = await repo.delete(id);
      return Response.ok(
        jsonEncode(item),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  // TODO: do better handling
  return Response.badRequest();
}
