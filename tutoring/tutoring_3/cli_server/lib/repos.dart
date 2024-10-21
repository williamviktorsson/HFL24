import 'package:cli_shared/cli_shared.dart';

part 'repo_impls.dart';


abstract class Repository<T> {
  List<T> _items = [];

  void add(T item) {
    _items.add(item);
  }

  List<T> getAll() {
    return _items;
  }

  T getById(int id);

  void update(int id, T newItem);

  void delete(T item) {
    _items.remove(item);
  }
}
