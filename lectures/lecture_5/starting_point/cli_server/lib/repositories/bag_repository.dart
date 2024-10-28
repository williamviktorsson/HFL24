import 'dart:convert';
import 'dart:io';

import 'package:cli_server/router_config.dart';
import 'package:cli_shared/cli_shared.dart';

class BagRepository implements RepositoryInterface<Bag> {
  String path = "./bags.json";

  @override
  Future<Bag> create(Bag bag) async {
    File file = File(path);

    try {
      await file.create(exclusive: true);
      await file.writeAsString(jsonEncode([]));
    } catch (e) {
      // file already exists
    }

    String content = await file.readAsString();

    var json = jsonDecode(content) as List;

    json = [...json, bag.toJson()];

    await file.writeAsString(jsonEncode(json));

    return bag;
  }

  @override
  Future<Bag?> getById(Id id) async {
    File file = File(path);

    try {
      await file.create(exclusive: true);
      await file.writeAsString(jsonEncode([]));
    } catch (e) {
      // file already exists
    }

    String content = await file.readAsString();

    List<Bag> bags = (jsonDecode(content) as List)
        .map((json) => Bag.fromJson(json))
        .toList();

    for (var bag in bags) {
      if (bag.id == id) {
        return bag;
      }
    }
    return null;
  }

  @override
  Future<List<Bag>> getAll() async {
    File file = File(path);

    try {
      await file.create(exclusive: true);
      await file.writeAsString(jsonEncode([]));
    } catch (e) {
      // file already exists
    }

    String content = await file.readAsString();

    List<Bag> bags = (jsonDecode(content) as List)
        .map((json) => Bag.fromJson(json))
        .toList();

    return bags;
  }

  @override
  Future<Bag?> update(Id id, Bag newBag) async {
    File file = File(path);

    try {
      await file.create(exclusive: true);
      await file.writeAsString(jsonEncode([]));
    } catch (e) {
      // file already exists
    }

    String content = await file.readAsString();

    List<Bag> bags = (jsonDecode(content) as List)
        .map((json) => Bag.fromJson(json))
        .toList();

    for (var i = 0; i < bags.length; i++) {
      if (bags[i].id == id) {
        bags[i] = newBag;

        await file.writeAsString(
            jsonEncode(bags.map((bag) => bag.toJson()).toList()));

        return newBag;
      }
    }

    return null;
  }

  @override
  Future<Bag?> delete(Id id) async {
    File file = File(path);

    try {
      await file.create(exclusive: true);
      await file.writeAsString(jsonEncode([]));
    } catch (e) {
      // file already exists
    }

    String content = await file.readAsString();

    List<Bag> bags = (jsonDecode(content) as List)
        .map((json) => Bag.fromJson(json))
        .toList();

    for (var i = 0; i < bags.length; i++) {
      if (bags[i].id == id) {
        final bag = bags.removeAt(i);
        await file.writeAsString(
            jsonEncode(bags.map((bag) => bag.toJson()).toList()));
        return bag;
      }
    }

    return null;
  }
}
