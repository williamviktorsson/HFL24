import 'package:admin_app/bloc/items_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:client_repositories/async_http_repos.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared/shared.dart';

void main() {
  group('ItemsBloc', () {
    late ItemRepository itemRepository;

    setUp(() {
      itemRepository = ItemRepository();
    });

    group("create test", () {
      Item newItem = Item("new item");

      blocTest<ItemsBloc, ItemsState>("create item test",
          build: () => ItemsBloc(repository: itemRepository),
          seed: () => ItemsLoaded(items: []),
          act: (bloc) => bloc.add(CreateItem(item: newItem)),
          expect: () => [
                ItemsLoaded(
                    items: [newItem], pending: newItem), // optimistic update,
                ItemsLoaded(items: [newItem], pending: null) // update succeded
              ],
          wait: Duration(seconds: 5));
    });
  });
}
