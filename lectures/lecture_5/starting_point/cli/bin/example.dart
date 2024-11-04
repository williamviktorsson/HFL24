import 'package:cli/repositories/item_repository.dart';
import 'package:cli_shared/cli_shared.dart';

void main() async {
  // Create an instance of ItemRepository
  ItemRepository repository = ItemRepository();

  // Add items to the repository
  await repository.create(Item('Item 1'));
  await repository.create(Item('Item 2'));
  await repository.create(Item('Item 3'));

  // Get all items
  List<Item> allItems = await repository.getAll();
  print('All items:');


  for (var Item(:description) in allItems) {
    print(description);
  }

  // Get item by index
  var Item(:description) = allItems.elementAt(0);
  print('\nItem at index 0: $description');

  var Item(:id) = allItems.elementAt(1);

  // Update an item
  Item updatedItem = Item('Updated Item 2', id);
  await repository.update(updatedItem.id, updatedItem);

  allItems = await repository.getAll();

  var [_, second,...] = allItems;

  print('\nUpdated item at index 1: ${second.description}');

  Item? item3 = allItems.elementAt(2);

  // Delete an item
  await repository.delete(item3.id);
  print('\nAll items after deleting item at index 2:');
  allItems = await repository.getAll();
  allItems.forEach((item) => print(item.description));
}