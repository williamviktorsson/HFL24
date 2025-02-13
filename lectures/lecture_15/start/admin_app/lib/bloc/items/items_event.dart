part of 'items_bloc.dart';

sealed class ItemsEvent {}

class SubscribeToUserItems extends ItemsEvent {
  final String userId;

  SubscribeToUserItems({required this.userId});
}


class UpdateItem extends ItemsEvent {
  final Item item;

  UpdateItem({required this.item});
}

class CreateItem extends ItemsEvent {
  final Item item;

  CreateItem({required this.item});
}

class DeleteItem extends ItemsEvent {
  final Item item;

  DeleteItem({required this.item});
}
