import 'dart:async';
import 'dart:isolate';

import 'package:cli/menus/main_menu.dart';

void main(List<String> args) async {
  // set timer to write out a second every second

  Timer timer = Timer.periodic(Duration(seconds: 1), (timer) {
    print(DateTime.now());
  });

  await Isolate.run(() => MainMenu.prompt());
}
