// items_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:client_repositories/async_http_repos.dart';
import 'package:equatable/equatable.dart';
import 'package:shared/shared.dart';

part 'items_event.dart';
part 'items_state.dart';

// BLoC
class ItemsBloc extends Bloc<ItemsEvent, ItemsState> {
  final ItemRepository _itemRepository;

  ItemsBloc({
    required ItemRepository itemRepository,
  })  : _itemRepository = itemRepository,
        super(const ItemsInitial()) {
    on<LoadItems>(_onLoadItems);
    on<CreateItem>(_onCreateItem);
    on<UpdateItem>(_onUpdateItem);
    on<DeleteItem>(_onDeleteItem);
    on<ReloadItems>(_onReloadItems);
  }

  Future<void> _onLoadItems(
    LoadItems event,
    Emitter<ItemsState> emit,
  ) async {
    emit(const ItemsLoading());


    try {
      final items = await _itemRepository.getAll();
      emit(ItemsLoaded(items));
    } catch (e) {
      emit(ItemsError(e.toString()));
    }
  }

  Future<void> _onReloadItems(
    ReloadItems event,
    Emitter<ItemsState> emit,
  ) async {
    final List<Item> items = switch (state) {
      ItemsLoaded(items: var items) ||
      ItemsReloading(items: var items) =>
        items,
      _ => [],
    };

    emit(ItemsReloading(items, changedItem: event.changedItem));

    try {
      final items = await _itemRepository.getAll();
      emit(ItemsLoaded(items));
    } catch (e) {
      emit(ItemsError(e.toString()));
    }
  }

  Future<void> _onCreateItem(
    CreateItem event,
    Emitter<ItemsState> emit,
  ) async {
    try {
      final List<Item> items = switch (state) {
        ItemsLoaded(items: var items) ||
        ItemsReloading(items: var items) =>
          items,
        _ => [],
      };

      await _itemRepository.create(event.item); // instant locally
      emit(ItemsReloading([...items, event.item], changedItem: event.item));
      add(ReloadItems(changedItem: event.item));
    } catch (e) {
      emit(ItemsError(e.toString()));
    }
  }

  Future<void> _onUpdateItem(
    UpdateItem event,
    Emitter<ItemsState> emit,
  ) async {
    try {
      await _itemRepository.update(
        event.item.id,
        event.item,
      );

      add(ReloadItems(changedItem: event.item));
    } catch (e) {
      emit(ItemsError(e.toString()));
    }
  }

  Future<void> _onDeleteItem(
    DeleteItem event,
    Emitter<ItemsState> emit,
  ) async {
    try {
      await _itemRepository.delete(event.item.id);
      add(ReloadItems(changedItem: event.item));
    } catch (e) {
      emit(ItemsError(e.toString()));
    }
  }
}
