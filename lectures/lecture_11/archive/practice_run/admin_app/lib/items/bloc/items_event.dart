part of 'items_bloc.dart';

// Events
sealed class ItemsEvent extends Equatable {
  const ItemsEvent();

  @override
  List<Object?> get props => [];
}

final class LoadItems extends ItemsEvent {
  const LoadItems();
}

final class ReloadItems extends ItemsEvent {

  final Item? changedItem;

  const ReloadItems({this.changedItem});
}


final class CreateItem extends ItemsEvent {
  final Item item;
  const CreateItem(this.item);

  @override
  List<Object?> get props => [item];
}

final class UpdateItem extends ItemsEvent {
  final Item item;
  const UpdateItem(this.item);

  @override
  List<Object?> get props => [item];
}

final class DeleteItem extends ItemsEvent {
  final Item item;
  const DeleteItem(this.item);

  @override
  List<Object?> get props => [item];
}