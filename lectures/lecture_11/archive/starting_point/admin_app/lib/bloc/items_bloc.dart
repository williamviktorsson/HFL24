// items_bloc.dart
import 'dart:convert';

import 'package:client_repositories/async_http_repos.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:shared/shared.dart';

part 'items_event.dart';
part 'items_state.dart';

// BLoC
class ItemsBloc extends HydratedBloc<ItemsEvent, ItemsState> {
  final ItemRepository _itemRepository;

  ItemsBloc({
    required ItemRepository itemRepository,
  })  : _itemRepository = itemRepository,
        super(const ItemsInitial()) {
    on<LoadItems>(_onLoadItems);
    on<RefreshItems>(_onRefreshItems);
    on<CreateItem>(_onCreateItem);
    on<UpdateItem>(_onUpdateItem);
    on<DeleteItem>(_onDeleteItem);
    on<SyncItem>(_onSyncItem);
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

  Future<void> _onRefreshItems(
    RefreshItems event,
    Emitter<ItemsState> emit,
  ) async {
    final List<Item> items = switch (state) {
      ItemsLoaded(items: var items) || ItemSyncing(items: var items) => items,
      _ => [],
    };

    emit(ItemSyncing(items, changedItem: event.changedItem));

    try {
      final items = await _itemRepository.getAll();
      items.shuffle();
      emit(ItemsLoaded(items));
    } catch (e) {
      emit(ItemsError(e.toString()));
    }
  }

  Future<void> _onSyncItem(
    SyncItem event,
    Emitter<ItemsState> emit,
  ) async {
    final List<Item> items = switch (state) {
      ItemsLoaded(items: var items) || ItemSyncing(items: var items) => items,
      _ => [],
    };

    emit(ItemSyncing(items, changedItem: event.changedItem));
  }

  Future<void> _onCreateItem(
    CreateItem event,
    Emitter<ItemsState> emit,
  ) async {
    try {
      final List<Item> items = switch (state) {
        ItemsLoaded(items: var items) || ItemSyncing(items: var items) => items,
        _ => [],
      };

      emit(ItemSyncing([...items, event.item], changedItem: event.item));
      await _itemRepository.create(event.item);
      final newItems = await _itemRepository.getAll();
      emit(ItemsLoaded(newItems));
    } catch (e) {
      emit(ItemsError(e.toString()));
    }
  }

  Future<void> _onUpdateItem(
    UpdateItem event,
    Emitter<ItemsState> emit,
  ) async {
    try {
      // TODO: trigger pending change, update local state

      // update happens immediately (on local)
      add(SyncItem(changedItem: event.item));

      await _itemRepository.update(
        event.item.id,
        event.item,
      );

      // syncItem event triggers getAll while showing pending state
      final newItems = await _itemRepository.getAll();
      emit(ItemsLoaded(newItems));
    } catch (e) {
      emit(ItemsError(e.toString()));
    }
  }

  Future<void> _onDeleteItem(
    DeleteItem event,
    Emitter<ItemsState> emit,
  ) async {
    try {
      add(SyncItem(changedItem: event.item));
      await _itemRepository.delete(event.item.id);
      final newItems = await _itemRepository.getAll();
      emit(ItemsLoaded(newItems));
    } catch (e) {
      emit(ItemsError(e.toString()));
    }
  }

  @override
  ItemsState? fromJson(Map<String, dynamic> stored) {
    // TODO: implement fromJson
    final String? items = stored["items"]; // null if on first read maybe?

    if (items == null) {
      return const ItemsInitial();
    } else {
      return ItemsLoaded((json.decode(items) as List)
          .map((itemJson) => Item.fromJson(itemJson))
          .toList());
    }
  }

  @override
  Map<String, dynamic>? toJson(ItemsState state) {
    return {
      "items": switch (state) {
        ItemsLoaded(items: final items) ||
        ItemSyncing(items: final items) =>
          json.encode(items.map((item) => item.toJson()).toList()),
        _ => null,
      }
    };
  }
}
