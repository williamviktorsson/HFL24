import 'package:admin_app/bloc/items_bloc.dart';
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

    group('UpdateItem', () {
      final updatedItem = Item('Updated item description', 1);
      final existingItems = [
        Item('First item description', 1),
        Item('Second item description', 2),
      ];

      blocTest<ItemsBloc, ItemsState>('emits [ItemsLoaded] when successful',
          // TODO, setup mock, build bloc, seed, act, expect, verify
          // TODO, verify itemrepository call count
          // expect states
          setUp: () {
            //when from mocktail
            when(() => itemRepository.update(any(), any()))
                .thenAnswer((_) async => updatedItem);
            when(() => itemRepository.getAll())
                .thenAnswer((_) async => [updatedItem, existingItems[1]]);
          },
          build: () => ItemsBloc(itemRepository: itemRepository),
          seed: () => ItemsLoaded(existingItems),
          act: (bloc) => bloc.add(UpdateItem(updatedItem)),
          expect: () => [
                ItemsLoaded([updatedItem, existingItems[1]])
              ],
          verify: (bloc) => {
                // verify method from mocktail
                verify(() => {
                      itemRepository.update(updatedItem.id, updatedItem)
                    }).called(1)
              });
    });
  });
}
