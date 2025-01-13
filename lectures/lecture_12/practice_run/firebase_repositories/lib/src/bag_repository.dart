import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared/shared.dart';

class BagRepository implements RepositoryInterface<Bag> {
  final db = FirebaseFirestore.instance;

  @override
  Future<Bag> getById(String id) async {
    final doc = await db.collection('bags').doc(id).get();

    final json = doc.data();

    if (json == null) {
      throw Exception('Bag not found');
    }

    return Bag.fromJson(json);
  }

  @override
  Future<Bag> create(Bag bag) async {
    await db.collection('bags').doc(bag.id).set(bag.toJson());

    return bag;
  }

  Future<List<Bag>> getAll() async {
    await Future.delayed(Duration(seconds: 2));

    final snapshot = await db.collection('bags').get();

    final jsons = snapshot.docs.map((doc) => doc.data()).toList();

    return jsons.map((bag) => Bag.fromJson(bag)).toList();
  }

  @override
  Future<Bag> delete(String id) async {
    final doc = await db.collection('bags').doc(id).get();

    final json = doc.data();

    if (json == null) {
      throw Exception('Bag not found');
    }

    await db.collection('bags').doc(id).delete();

    return Bag.fromJson(json);
  }

  @override
  Future<Bag> update(String id, Bag bag) async {
    await db.collection('bags').doc(id).set(bag.toJson());

    return bag;
  }
}
