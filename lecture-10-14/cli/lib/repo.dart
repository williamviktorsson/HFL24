import 'dart:convert';

import 'package:cli/models.dart';

import 'package:http/http.dart' as http;

abstract class NetworkedRepository<T> {
  String host;
  String port;
  String resource;

  Map<String, dynamic> serialize(T item);
  T deserialize(Map<String, dynamic> json);

  NetworkedRepository(
      {required this.resource,
      this.host = "http://localhost",
      this.port = "8080"});

  Future<void> add(T item) async {
    // send item serialized as json over http to server at localhost:8080
    final uri = Uri.parse("${host}:${port}/${resource}");

    await http.post(uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(serialize(item)));
  }

  Future<List<T>> getAll() async {
    final uri = Uri.parse("${host}:${port}/${resource}");
    final response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    final json = jsonDecode(response.body);

    return (json as List).map((item) => deserialize(item)).toList();
  }

  Future<void> update(T item, T newItem) async {
    throw Error();
  }

  Future<void> delete(T item) async {
    throw Error();
  }
}

class ItemRepository extends NetworkedRepository<Item> {
  ItemRepository() : super(resource: "items");

  @override
  Item deserialize(Map<String, dynamic> json) => Item.fromJson(json);

  @override
  Map<String, dynamic> serialize(Item item) => item.toJson();
}
