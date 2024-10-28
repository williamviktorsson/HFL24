import 'package:cli/repositories/item_repository.dart';
import 'package:cli_shared/cli_shared.dart';

void main() async {
  // Create an instance of ItemRepository
  ItemRepository repository = ItemRepository();

  List<Item> allItems = await repository.getAll();

  if (allItems.length < 6) {
    int itemsToCreate = 6;
    for (int i = allItems.length; i < itemsToCreate; i++) {
      Id id = Id.unique();

      await repository.create(Item(description: 'Item $id', id: id));
    }
  }

  // Get all items
  allItems = await repository.getAll();
  print('All items:');
  for (var Item(:description) in allItems) {
    print(description);
  }

  // Get item by index
  var Item(:description, :id) = allItems.elementAt(0);
  print('\nItem at index 0: $description');

  Item(:id, :description) = allItems.elementAt(1);

  // Update an item
  Item updatedItem = Item(description: 'Updated $id', id: id);
  await repository.update(updatedItem.id, updatedItem);

  allItems = await repository.getAll();

  print('\nUpdated item at index 1: ${allItems.elementAt(1).description}');

  var [first, _, third, ..., last] = allItems;
  print("\nFirst item: ${first.description}");
  print("Third item: ${third.description}");
  print("Last item: ${last.description}");

  Item(:id) = allItems.elementAt(2);

  // Delete an item
  await repository.delete(id);
  print('\nAll items after deleting item at index 2:');
  allItems = await repository.getAll();
  for (var Item(:description) in allItems) {
    print(description);
  }
}
