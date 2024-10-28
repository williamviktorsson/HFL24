import 'package:cli_shared/src/models/utils.dart';

abstract interface class RepositoryInterface<T> {
  Future<T?> create(T item);
  Future<List<T>> getAll();
  Future<T?> getById(Id id);
  Future<T?> update(Id id, T item);
  Future<T?> delete(Id id);
}
