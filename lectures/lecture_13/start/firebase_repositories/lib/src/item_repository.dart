import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared/shared.dart';

class ItemRepository implements RepositoryInterface<Item> {
  final db = FirebaseFirestore.instance;

  @override
  Future<Item> getById(String id) async {
    final snapshot = await db.collection("items").doc(id).get();

    final json = snapshot.data();

    if (json == null) {
      throw Exception("Item with id $id not found");
    }

    return Item.fromJson(json);
  }

  @override
  Future<Item> create(Item item) async {

    await db.collection("items").doc(item.id).set(item.toJson());

    return item;
  }

  @override
  Future<List<Item>> getAll() async {
    final snapshots = await db.collection("items").get();

    final docs = snapshots.docs;

    final jsons = docs.map((doc) {
      final json = doc.data();

      return json;
    }).toList();

    return jsons.map((json) => Item.fromJson(json)).toList();
  }

  @override
  Future<Item> delete(String id) async {
    final item = await getById(id);

    await db.collection("items").doc(id).delete();

    return item;
  }

  @override
  Future<Item> update(String id, Item item) async {
    await db.collection("items").doc(item.id).set(item.toJson());

    return item;
  }

  Stream<List<Item>> userItemsStream(String userId) {
    return db
        .collection("items")
        .where("creatorId", isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      final docs = snapshot.docs;
      return docs.map((doc) => Item.fromJson(doc.data())).toList();
    });
  }
}
