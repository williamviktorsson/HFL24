import 'dart:convert';
import 'dart:io';

import 'package:cli_shared/cli_shared.dart';

class ItemRepository implements RepositoryInterface<Item> {
  String path = "./items.json";

  @override
  Future<Item> create(Item item) async {
    File file = File(path);

    try {
      await file.create(exclusive: true);
      await file.writeAsString(jsonEncode([]));
    } catch (e) {
      // file already exists
    }

    String content = await file.readAsString();

    var json = jsonDecode(content) as List;

    json = [...json, item.toJson()];

    await file.writeAsString(jsonEncode(json));

    return item;
  }

  @override
  Future<Item?> getById(String id) async {
    File file = File(path);

    try {
      await file.create(exclusive: true);
      await file.writeAsString(jsonEncode([]));
    } catch (e) {
      // file already exists
    }

    String content = await file.readAsString();

    List<Item> items = (jsonDecode(content) as List)
        .map((json) => Item.fromJson(json))
        .toList();

    for (var item in items) {
      if (item.id == id) {
        return item;
      }
    }
    return null;
  }

  @override
  Future<List<Item>> getAll() async {
    File file = File(path);

    try {
      await file.create(exclusive: true);
      await file.writeAsString(jsonEncode([]));
    } catch (e) {
      // file already exists
    }

    String content = await file.readAsString();

    List<Item> items = (jsonDecode(content) as List)
        .map((json) => Item.fromJson(json))
        .toList();

    return items;
  }

  @override
  Future<Item?> update(String id, Item newItem) async {
    File file = File(path);

    try {
      await file.create(exclusive: true);
      await file.writeAsString(jsonEncode([]));
    } catch (e) {
      // file already exists
    }

    String content = await file.readAsString();

    List<Item> items = (jsonDecode(content) as List)
        .map((json) => Item.fromJson(json))
        .toList();

    for (var i = 0; i < items.length; i++) {
      if (items[i].id == id) {
        items[i] = newItem;

        await file.writeAsString(
            jsonEncode(items.map((item) => item.toJson()).toList()));

        return newItem;
      }
    }

    return null;
  }

  @override
  Future<Item?> delete(String id) async {
    File file = File(path);

    try {
      await file.create(exclusive: true);
      await file.writeAsString(jsonEncode([]));
    } catch (e) {
      // file already exists
    }

    String content = await file.readAsString();

    List<Item> items = (jsonDecode(content) as List)
        .map((json) => Item.fromJson(json))
        .toList();

    for (var i = 0; i < items.length; i++) {
      if (items[i].id == id) {
        final item = items.removeAt(i);
        await file.writeAsString(
            jsonEncode(items.map((item) => item.toJson()).toList()));
        return item;
      }
    }

    return null;
  }
}
