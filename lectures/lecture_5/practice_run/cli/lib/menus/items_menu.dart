import 'dart:io';

import 'package:cli/cli_operations/items_operations.dart';
import 'package:cli/utils/console.dart';

enum ItemOperation {
  create,
  read,
  update,
  delete,
  back,
  invalid;

  factory ItemOperation.fromInt(int? value) {
    switch (value) {
      case 1:
        return ItemOperation.create;
      case 2:
        return ItemOperation.read;
      case 3:
        return ItemOperation.update;
      case 4:
        return ItemOperation.delete;
      case 5:
        return ItemOperation.back;
      default:
        return ItemOperation.invalid;
    }
  }
}

class ItemsMenu {
  static Future prompt() async {
    clearConsole();
    while (true) {
      print('Items Menu');
      print('1. Create Item');
      print('2. List all Items');
      print('3. Update Item');
      print('4. Delete Item');
      print('5. Back to Main Menu');

      var input = choice();

      switch (ItemOperation.fromInt(input)) {
        case ItemOperation.create:
          print('Creating Item');
          await ItemsOperations.create();
        case ItemOperation.read:
          print('Listing all Items');
          await ItemsOperations.list();
        case ItemOperation.update:
          print('Updating Item');
          await ItemsOperations.update();
        case ItemOperation.delete:
          print('Deleting Item');
          await ItemsOperations.delete();
        case ItemOperation.back:
          return;
        case ItemOperation.invalid: // added to match the menu
          print("Invalid choice");
      }
      print("\n------------------------------------\n");
    }
  }
}
