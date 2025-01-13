import 'package:admin_app/bloc/items_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_repositories/firebase_repositories.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared/shared.dart';

class MockItemRepository extends Mock implements ItemRepository {}

class FakeItem extends Fake implements Item {}

void main() {
  group('ItemsBloc', () {
    late ItemRepository itemRepository;

    setUp(() {
      itemRepository = MockItemRepository();
    });

    setUpAll(() {
      // TODO: check if this errors on any
      registerFallbackValue(FakeItem());
    });

    group("create test", () {
      Item newItem = Item("new item");

      blocTest<ItemsBloc, ItemsState>("create item test",
          setUp: () {
            when(() => itemRepository.create(any()))
                .thenAnswer((_) async => newItem);
            when(() => itemRepository.getAll())
                .thenAnswer((_) async => [newItem]);
          },
          build: () => ItemsBloc(repository: itemRepository),
          seed: () => ItemsLoaded(items: []),
          act: (bloc) => bloc.add(CreateItem(item: newItem)),
          expect: () => [
                ItemsLoaded(
                    items: [newItem], pending: newItem), // optimistic update,
                ItemsLoaded(items: [newItem], pending: null) // update succeded
              ],
          verify: (_) {
            verify(() => itemRepository.create(newItem)).called(1);
          });

      blocTest<ItemsBloc, ItemsState>("create item test error",
          setUp: () {
            when(() => itemRepository.create(any()))
                .thenThrow(Exception("item create fail"));
          },
          build: () => ItemsBloc(repository: itemRepository),
          seed: () => ItemsLoaded(items: []),
          act: (bloc) => bloc.add(CreateItem(item: newItem)),
          expect: () => [
                ItemsLoaded(
                    items: [newItem], pending: newItem), // optimistic update,
                ItemsError(message: Exception("item create fail").toString()) // update failed
              ],
          verify: (_) {
            verify(() => itemRepository.create(newItem)).called(1);
          });
    });
  });
}
