import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_repositories/firebase_repositories.dart';
import 'package:shared/shared.dart';

part 'items_state.dart';
part 'items_event.dart';

class ItemsBloc extends Bloc<ItemsEvent, ItemsState> {
  final ItemRepository repository;

  ItemsBloc({required this.repository}) : super(ItemsInitial()) {
    on<ItemsEvent>((event, emit) async {
      try {
        switch (event) {
          case UpdateItem(item: final item):
            await onUpdateItem(item, emit);

          case CreateItem(item: final item):
            await onCreateItem(item, emit);

          case DeleteItem(item: final item):
            await onDeleteItem(emit, item);

          case SubscribeToUserItems(:final userId):
            return emit.onEach(
              repository.userItemsStream(userId),
              onData: (items) {
                return emit(ItemsLoaded(items: items));
              },
              onError: (error, stackTrace) {
                return emit(ItemsError(message: error.toString()));
              },
            );
        }
      } on Exception catch (e) {
        emit(ItemsError(message: e.toString()));
      }
    });
  }

  Future<void> onDeleteItem(Emitter<ItemsState> emit, Item item) async {
    final currentItems = switch (state) {
      ItemsLoaded(:final items) => [...items],
      _ => <Item>[],
    };
    emit(ItemsLoaded(items: currentItems, pending: item));

    await repository.delete(item.id);
  }

  Future<void> onCreateItem(Item item, Emitter<ItemsState> emit) async {
    final currentItems = switch (state) {
      ItemsLoaded(:final items) => [...items],
      _ => <Item>[],
    };
    currentItems.add(item); // add erik to currentItems
    emit(ItemsLoaded(
        items: currentItems,
        pending: item)); // optimistic update (indicate that "erik" is pe)

    await repository.create(item); // async operation mocked in test
  }

  Future<void> onUpdateItem(Item item, Emitter<ItemsState> emit) async {
    final currentItems = switch (state) {
      ItemsLoaded(:final items) => [...items],
      _ => <Item>[],
    };
    var index = currentItems.indexWhere((e) => item.id == e.id);
    currentItems.removeAt(index);
    currentItems.insert(index, item);
    emit(ItemsLoaded(items: currentItems, pending: item));
    await repository.update(item.id, item);
  }
}
