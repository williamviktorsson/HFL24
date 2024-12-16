import 'package:admin_app/items/bloc/items_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared/shared.dart';
import 'package:client_repositories/async_http_repos.dart';

class MockItemRepository extends Mock implements ItemRepository {}

class FakeItem extends Fake implements Item {
  @override
  String description;
  @override
  int id;

  FakeItem(this.description, [this.id = -1]);
}

void main() {
  group('ItemsBloc', () {
    late ItemRepository itemRepository;

    setUpAll(() {
      // register the fake item to be used with mocked calls
      registerFallbackValue(FakeItem('fake description'));
    });

    setUp(() {
      itemRepository = MockItemRepository();
    });

    ItemsBloc buildBloc() {

      // fetch new bloc for each test

      return ItemsBloc(
        itemRepository: itemRepository,
      );
    }

    group('constructor', () {
      test('works properly', () {
        expect(buildBloc, returnsNormally);
      });

      test('has correct initial state', () {
        expect(
          buildBloc().state,
          equals(const ItemsInitial()),
        );
      });
    });

    group('LoadItems', () {
      final items = [
        Item('First item description', 1),
        Item('Second item description', 2),
      ];

      blocTest<ItemsBloc, ItemsState>(
        'emits [ItemsLoading, ItemsLoaded] when successful',
        setUp: () {
          // setup the mock repo to return the items on load
          when(() => itemRepository.getAll()).thenAnswer((_) async => items);
        },
        build: buildBloc,
        act: (bloc) => bloc.add(const LoadItems()),
        expect: () => [
          const ItemsLoading(),
          ItemsLoaded(items),
        ],
        verify: (_) {
          verify(() => itemRepository.getAll()).called(1); // only gets called once on load
        },
      );

      blocTest<ItemsBloc, ItemsState>(
        'emits [ItemsLoading, ItemsError] when getAll fails',
        setUp: () {
          when(() => itemRepository.getAll())
              .thenThrow(Exception('Failed to load items'));
        },
        build: buildBloc,
        act: (bloc) => bloc.add(const LoadItems()),
        expect: () => [
          const ItemsLoading(),
          const ItemsError('Exception: Failed to load items'),
        ],
      );
    });

    group('CreateItem', () {
      final newItem = Item('New item description', 3);
      final existingItems = [
        Item('First item description', 1),
        Item('Second item description', 2),
      ];

      blocTest<ItemsBloc, ItemsState>(
        'emits [ItemsReloading, ItemsLoaded] when successful',
        setUp: () {
          when(() => itemRepository.create(any())).thenAnswer((_) async {
            return newItem;
          });
          when(() => itemRepository.getAll())
              .thenAnswer((_) async => [...existingItems, newItem]);
        },
        build: buildBloc,
        seed: () => ItemsLoaded(existingItems), // setup the initial state of the bloc before calling act
        act: (bloc) => bloc.add(CreateItem(newItem)),
        expect: () => [
          ItemsReloading([...existingItems, newItem], changedItem: newItem),
          ItemsLoaded([...existingItems, newItem]),
        ],
        verify: (_) {
          verify(() => itemRepository.create(newItem)).called(1);
          verify(() => itemRepository.getAll()).called(1);
        },
      );

      blocTest<ItemsBloc, ItemsState>(
        'emits [ItemsError] when create fails',
        setUp: () {
          when(() => itemRepository.create(any()))
              .thenThrow(Exception('Failed to create item'));
        },
        build: buildBloc,
        seed: () => ItemsLoaded(existingItems),
        act: (bloc) => bloc.add(CreateItem(newItem)),
        expect: () => [
          const ItemsError('Exception: Failed to create item'),
        ],
      );
    });

    group('UpdateItem', () {
      final updatedItem = Item('Updated item description', 1);
      final existingItems = [
        Item('First item description', 1),
        Item('Second item description', 2),
      ];

      blocTest<ItemsBloc, ItemsState>(
        'emits [ItemsReloading, ItemsLoaded] when successful',
        setUp: () {
          when(() => itemRepository.update(any(), any())).thenAnswer((_) async {
            return updatedItem;
          });
          when(() => itemRepository.getAll())
              .thenAnswer((_) async => [updatedItem, existingItems[1]]);
        },
        build: buildBloc,
        seed: () => ItemsLoaded(existingItems),
        act: (bloc) => bloc.add(UpdateItem(updatedItem)),
        expect: () => [
          ItemsReloading(existingItems, changedItem: updatedItem),
          ItemsLoaded([updatedItem, existingItems[1]]),
        ],
        verify: (_) {
          verify(() => itemRepository.update(updatedItem.id, updatedItem))
              .called(1);
          verify(() => itemRepository.getAll()).called(1);
        },
      );

      blocTest<ItemsBloc, ItemsState>(
        'emits [ItemsError] when update fails',
        setUp: () {
          when(() => itemRepository.update(any(), any()))
              .thenThrow(Exception('Failed to update item'));
        },
        build: buildBloc,
        seed: () => ItemsLoaded(existingItems),
        act: (bloc) => bloc.add(UpdateItem(updatedItem)),
        expect: () => [
          const ItemsError('Exception: Failed to update item'),
        ],
      );
    });

    group('DeleteItem', () {
      final itemToDelete = Item('First item description', 1);
      final existingItems = [
        Item('First item description', 1),
        Item('Second item description', 2),
      ];

      blocTest<ItemsBloc, ItemsState>(
        'emits [ItemsReloading, ItemsLoaded] when successful',
        setUp: () {
          when(() => itemRepository.delete(any())).thenAnswer((_) async {
            return itemToDelete;
          });
          when(() => itemRepository.getAll())
              .thenAnswer((_) async => [existingItems[1]]);
        },
        build: buildBloc,
        seed: () => ItemsLoaded(existingItems),
        act: (bloc) => bloc.add(DeleteItem(itemToDelete)),
        expect: () => [
          ItemsReloading(existingItems, changedItem: itemToDelete),
          ItemsLoaded([existingItems[1]]),
        ],
        verify: (_) {
          verify(() => itemRepository.delete(itemToDelete.id)).called(1);
          verify(() => itemRepository.getAll()).called(1);
        },
      );

      blocTest<ItemsBloc, ItemsState>(
        'emits [ItemsError] when delete fails',
        setUp: () {
          when(() => itemRepository.delete(any()))
              .thenThrow(Exception('Failed to delete item'));
        },
        build: buildBloc,
        seed: () => ItemsLoaded(existingItems),
        act: (bloc) => bloc.add(DeleteItem(itemToDelete)),
        expect: () => [
          const ItemsError('Exception: Failed to delete item'),
        ],
      );
    });

    group('ReloadItems', () {
      final items = [
        Item('First item description', 1),
        Item('Second item description', 2),
      ];
      final changedItem = Item('Changed item description', 1);

      blocTest<ItemsBloc, ItemsState>(
        'emits [ItemsReloading, ItemsLoaded] when successful',
        setUp: () {
          when(() => itemRepository.getAll()).thenAnswer((_) async => items);
        },
        build: buildBloc,
        seed: () => ItemsLoaded(items),
        act: (bloc) => bloc.add(ReloadItems(changedItem: changedItem)),
        expect: () => [
          ItemsReloading(items, changedItem: changedItem),
          ItemsLoaded(items),
        ],
        verify: (_) {
          verify(() => itemRepository.getAll()).called(1);
        },
      );

      blocTest<ItemsBloc, ItemsState>(
        'emits [ItemsReloading, ItemsError] when reload fails',
        setUp: () {
          when(() => itemRepository.getAll())
              .thenThrow(Exception('Failed to reload items'));
        },
        build: buildBloc,
        seed: () => ItemsLoaded(items),
        act: (bloc) => bloc.add(ReloadItems(changedItem: changedItem)),
        expect: () => [
          ItemsReloading(items, changedItem: changedItem),
          const ItemsError('Exception: Failed to reload items'),
        ],
      );
    });
  });
}
