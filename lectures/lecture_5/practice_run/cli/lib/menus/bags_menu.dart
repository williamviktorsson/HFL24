import 'dart:io';

import 'package:cli/cli_operations/bags_operations.dart';
import 'package:cli/utils/console.dart';

enum BagOperation {
  create,
  read,
  update,
  delete,
  back,
  invalid;

  factory BagOperation.fromInt(int? value) {
    switch (value) {
      case 1:
        return BagOperation.create;
      case 2:
        return BagOperation.read;
      case 3:
        return BagOperation.update;
      case 4:
        return BagOperation.delete;
      case 5:
        return BagOperation.back;
      default:
        return BagOperation.invalid;
    }
  }
}

class BagsMenu {
  static Future prompt() async {
    clearConsole();
    while (true) {
      print('Bags Menu');
      print('1. Create Bag');
      print('2. List all Bags');
      print('3. Update Bag');
      print('4. Delete Bag');
      print('5. Back to Main Menu');

      var input = choice();

      switch (BagOperation.fromInt(input)) {
        case BagOperation.create:
          print('Creating Bag');
          await BagsOperations.create();
        case BagOperation.read:
          print('Listing all Bags');
          await BagsOperations.list();
        case BagOperation.update:
          print('Updating Bag');
          await BagsOperations.update();
        case BagOperation.delete:
          print('Deleting Bag');
          await BagsOperations.delete();
        case BagOperation.back:
          return;
        case BagOperation.invalid:
          print("Invalid choice");
      }
      print("\n------------------------------------\n");
    }
  }
}
