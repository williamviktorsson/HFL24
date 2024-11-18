import 'package:shared/shared.dart';

class BagRepository implements RepositoryInterface<Bag> {
  // singleton

  BagRepository._internal() {
    bagIds = _bags.length;
  }

  static final BagRepository _instance = BagRepository._internal();

  static BagRepository get instance => _instance;

  final List<Bag> _bags = [
    Bag(description: "Brown leather trunk", items: [Item("Robe", 1)], id: 0)
  ];

  late int bagIds;

  @override
  Future<Bag> create(Bag bag) async {
    if (bag.id < 0) {
      bag.id = bagIds++;
    }
    _bags.add(bag);
    return bag;
  }

  @override
  Future<Bag> getById(int id) async {
    return _bags.firstWhere((e) => e.id == id);
  }

  @override
  Future<List<Bag>> getAll() async => List.from(_bags);

  @override
  Future<Bag> update(int id, Bag newBag) async {
    var index = _bags.indexWhere((e) => e.id == id);
    if (index >= 0 && index < _bags.length) {
      _bags[index] = newBag;
      return newBag;
    }
    throw RangeError.index(index, _bags);
  }

  @override
  Future<Bag> delete(int id) async {
    var index = _bags.indexWhere((e) => e.id == id);
    if (index >= 0 && index < _bags.length) {
      return _bags.removeAt(index);
    }
    throw RangeError.index(index, _bags);
  }
}
