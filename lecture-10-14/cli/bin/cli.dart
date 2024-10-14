import 'dart:convert';

import 'package:cli/models.dart';
import 'package:cli/repo.dart';

ItemRepository repository = ItemRepository();

ItemRepository repository2 = ItemRepository();

ItemRepository repository3 = ItemRepository();

void main() async {
  // Create an instance of ItemRepository
  ItemRepository repository = ItemRepository();

  // Add items to the repository
  await repository.add(Item('Item 1'));
  await repository.add(Item('Item 2'));
  await repository.add(Item('Item 3'));

  // Get all items
  List<Item> allItems = await repository.getAll();
  print('All items:');
  allItems.forEach((item) => print(item.description));

  // Get item by index
  Item? item = (await repository.getAll()).elementAt(0);
  print('\nItem at index 0: ${item?.description}');
/*
  // Update an item
  Item updatedItem = Item('Updated Item 2');
  await repository.update(item!, updatedItem);
  print(
      '\nUpdated item at index 1: ${(await repository.getAll()).elementAt(1).description}');

  // Delete an item
  await repository.delete(item);
  print('\nAll items after deleting item at index 1:');
  allItems = await repository.getAll();
  allItems.forEach((item) => print(item.description)); */
}
