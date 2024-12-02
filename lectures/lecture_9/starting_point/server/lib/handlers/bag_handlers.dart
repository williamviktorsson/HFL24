import 'dart:convert';

import 'package:server/repositories/bag_repository.dart';
import 'package:shared/shared.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

BagRepository repo = BagRepository();

Future<Response> postBagHandler(Request request) async {
  final data = await request.readAsString();
  final json = jsonDecode(data);
  var bag = Bag.fromJson(json);

  bag.brand = Brand(name: "Boogle");

  bag = await repo.create(bag);

  return Response.ok(
    jsonEncode(bag),
    headers: {'Content-Type': 'application/json'},
  );
}

Future<Response> getBagsHandler(Request request) async {
  final bags = await repo.getAll();

  final payload = bags.map((e) => e.toJson()).toList();

  print(payload);

  return Response.ok(
    jsonEncode(payload),
    headers: {'Content-Type': 'application/json'},
  );
}

Future<Response> getBagHandler(Request request) async {
  String? idStr = request.params["id"];

  if (idStr != null) {
    int? id = int.tryParse(idStr);

    if (id != null) {
      Bag? bag = await repo.getById(id);
      return Response.ok(
        jsonEncode(bag),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  // do better handling
  return Response.badRequest();
}

Future<Response> updateBagHandler(Request request) async {
  String? idStr = request.params["id"];

  if (idStr != null) {
    int? id = int.tryParse(idStr);

    if (id != null) {
      final data = await request.readAsString();
      final json = jsonDecode(data);
      var bag = Bag.fromJson(json);
      bag = await repo.update(id, bag);
      return Response.ok(
        jsonEncode(bag),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  // TODO: do better handling
  return Response.badRequest();
}

Future<Response> deleteBagHandler(Request request) async {
  String? id_str = request.params["id"];

  if (id_str != null) {
    int? id = int.tryParse(id_str);

    if (id != null) {
      Bag? bag = await repo.delete(id);
      return Response.ok(
        jsonEncode(bag),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  // TODO: do better handling
  return Response.badRequest();
}
