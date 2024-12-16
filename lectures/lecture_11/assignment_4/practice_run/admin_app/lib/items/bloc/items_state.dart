part of 'items_bloc.dart';

// States

sealed class ItemsState extends Equatable {
  const ItemsState();

  @override
  List<Object?> get props => [];
}

final class ItemsInitial extends ItemsState {
  const ItemsInitial();
}

final class ItemsLoading extends ItemsState {
  const ItemsLoading();
}

final class ItemsLoaded extends ItemsState {
  final List<Item> items;
  
  const ItemsLoaded(this.items);

  @override
  List<Object?> get props => [items];
}

final class ItemsReloading extends ItemsState {
  final List<Item> items;

  final Item? changedItem;
  
  const ItemsReloading(this.items, {this.changedItem});

  @override
  List<Object?> get props => [items,changedItem];
}

final class ItemsError extends ItemsState {
  final String message;
  
  const ItemsError(this.message);

  @override
  List<Object?> get props => [message];
}