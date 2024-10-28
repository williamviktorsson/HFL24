import 'package:cli/utils/console.dart';
import 'package:cli/menus/bags_menu.dart';
import 'package:cli/menus/items_menu.dart';

enum MainOperation {
  items,
  bags,
  exit,
  invalid;

  factory MainOperation.fromInt(int? value) {
    switch (value) {
      case 1:
        return MainOperation.items;
      case 2:
        return MainOperation.bags;
      case 3:
        return MainOperation.exit;
      default:
        return MainOperation.invalid;
    }
  }
}

class MainMenu {
  static Future prompt() async {
    clearConsole();

    while (true) {
      // clear the console

      // prompt options to edit items, bags, or exit
      print('Main Menu');
      print('1. Manage Items');
      print('2. Manage Bags');
      print('3. Exit');
      var input = choice();
      switch (MainOperation.fromInt(input)) {
        case MainOperation.items:
          await ItemsMenu.prompt();
        case MainOperation.bags:
          await BagsMenu.prompt();
        case MainOperation.exit:
          return;
        case MainOperation.invalid:
          print('Invalid choice');
      }
      print("\n------------------------------------\n");
    }
  }
}
