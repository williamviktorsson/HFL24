import 'dart:convert';
import 'package:shared/shared.dart';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class ItemRepository implements RepositoryInterface<Item> {
  // singleton
  ItemRepository._internal();

  static final ItemRepository _instance = ItemRepository._internal();

  static ItemRepository get instance => _instance;

  @override
  Future<Item> getById(int id) async {
    final uri = Uri.parse("http://localhost:8080/items/${id}");

    Response response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    final json = jsonDecode(response.body);

    return Item.fromJson(json);
  }

  @override
  Future<Item> create(Item item) async {
    // send item serialized as json over http to server at localhost:8080
    final uri = Uri.parse("http://localhost:8080/items");

    Response response = await http.post(uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(item.toJson()));

    final json = jsonDecode(response.body);

    return Item.fromJson(json);
  }

  Future<List<Item>> getAll() async {
    final uri = Uri.parse("http://localhost:8080/items");
    final response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    final json = jsonDecode(response.body);

    return (json as List).map((item) => Item.fromJson(item)).toList();
  }

  @override
  Future<Item> delete(int id) async {
    final uri = Uri.parse("http://localhost:8080/items/${id}");

    Response response = await http.delete(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    final json = jsonDecode(response.body);

    return Item.fromJson(json);
  }

  @override
  Future<Item> update(int id, Item item) async {
    // send item serialized as json over http to server at localhost:8080
    final uri = Uri.parse("http://localhost:8080/items/${id}");

    Response response = await http.put(uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(item.toJson()));

    final json = jsonDecode(response.body);

    return Item.fromJson(json);
  }
}
