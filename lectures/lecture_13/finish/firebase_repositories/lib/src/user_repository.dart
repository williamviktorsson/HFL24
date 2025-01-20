import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared/shared.dart';

class UserRepository implements RepositoryInterface<User> {
  final db = FirebaseFirestore.instance;

  @override
  Future<User> getById(String id) async {
    final snapshot = await db.collection("users").doc(id).get();

    final json = snapshot.data();

    if (json == null) {
      throw Exception("User with id $id not found");
    }


    return User.fromJson(json);
  }

  Future<User?> getByAuthId(String authId) async {
    final snapshot = await db.collection("users").where("authId", isEqualTo: authId).get();

    if (snapshot.docs.isEmpty) {
      return null;
    }

    final json = snapshot.docs.first.data();

    return User.fromJson(json);
  }

  @override
  Future<User> create(User user) async {

    await Future.delayed(Duration(seconds: 5));

    await db.collection("users").doc(user.id).set(user.toJson());

    return user;
  }

  @override
  Future<List<User>> getAll() async {
    final snapshots = await db.collection("users").get();

    final docs = snapshots.docs;

    final jsons = docs.map((doc) {
      final json = doc.data();

      return json;
    }).toList();

    return jsons.map((json) => User.fromJson(json)).toList();
  }

  @override
  Future<User> delete(String id) async {
    final user = await getById(id);

    await db.collection("users").doc(id).delete();

    return user;
  }

  @override
  Future<User> update(String id, User user) async {
    await db.collection("users").doc(user.id).set(user.toJson());

    return user;
  }
}
