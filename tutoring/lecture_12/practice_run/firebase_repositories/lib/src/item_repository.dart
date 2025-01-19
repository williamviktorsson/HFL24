import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared/shared.dart';

class ItemRepository implements RepositoryInterface<Item> {
  final db = FirebaseFirestore.instance;

  @override
  Future<Item> getById(String id) async {
    final doc = await db.collection('items').doc(id).get();

    final json = doc.data();

    if (json == null) {
      throw Exception('Item not found');
    }

    return Item.fromJson(json);
  }

  @override
  Future<Item> create(Item item) async {
    await db.collection('items').doc(item.id).set(item.toJson());

    return item;
  }

  Future<List<Item>> getAll() async {
    await Future.delayed(Duration(seconds: 2));

    final snapshot = await db.collection('items').get();

    final jsons = snapshot.docs.map((doc) => doc.data()).toList();

    return jsons.map((item) => Item.fromJson(item)).toList();
  }

  @override
  Future<Item> delete(String id) async {
    final doc = await db.collection('items').doc(id).get();

    final json = doc.data();

    if (json == null) {
      throw Exception('Item not found');
    }

    await db.collection('items').doc(id).delete();

    return Item.fromJson(json);
  }

  @override
  Future<Item> update(String id, Item item) async {
    await db.collection('items').doc(id).set(item.toJson());

    return item;
  }
}
