import 'dart:convert';

import 'package:cli_server/globals.dart';
import 'package:cli_server/repos.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

int counter = 0;

Future<Response> postItemHandler(Request request) async {
  final data = await request.readAsString();
  final json = jsonDecode(data);
  final item = Item.fromJson(json);

  final itemWithId = Item(item.description, counter++);

  repo.add(itemWithId);

  return Response.ok(null);
}

Future<Response> getItemsHandler(Request request) async {
  final items = repo.getAll().map((e) => e.toJson()).toList();

  return Response.ok(
    jsonEncode(items),
    headers: {'Content-Type': 'application/json'},
  );
}

Future<Response> getItemHandler(Request request) async {
  String? id_str = request.params["id"];

  if (id_str != null) {
    int? id = int.tryParse(id_str);

    if (id != null) {
      Item? item = repo.getById(id);
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
  String? id_str = request.params["id"];

  print(id_str);

  if (id_str != null) {
    int? id = int.tryParse(id_str);

    print(id);

    if (id != null) {
      final data = await request.readAsString();
      final json = jsonDecode(data);
      final item = Item.fromJson(json);
      repo.update(id, item);
      return Response.ok(
        jsonEncode(item),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  // do better handling
  return Response.badRequest();
}
