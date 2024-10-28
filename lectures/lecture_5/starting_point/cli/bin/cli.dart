import 'dart:async';
import 'dart:isolate';

import 'package:cli/menus/main_menu.dart';
import 'package:cli_shared/cli_shared.dart';

var state = 5;

void main(List<String> args) async {
  // main isolate will handle printing seconds

  var one = Isolate.run(() async {
    await Future.delayed(Duration(seconds: 5));
    return Id(id: "id");
  });

  var two = Isolate.run(() async {
    await Future.delayed(Duration(seconds: 5));
    return Id(id: "id");
  });
  var three = Isolate.run(() async {
    await Future.delayed(Duration(seconds: 5));
    return 123;
  });
  var four = Isolate.run(() async {
    await Future.delayed(Duration(seconds: 5));
    return Id(id: "id");
  });

  var tuple = await Future.wait([one, two, three, four]).then((results) {
    return (results[0], results[1], results[2], results[3]);
  });

  // everything runs on the same main isolate
  await Isolate.run(() async {
    Timer.periodic(Duration(seconds: 1), (timer) {
      state++;
      print(state.toString() + " in second isolate");
    });
    await Isolate.run(() async {
      await MainMenu.prompt();
    });
  });
}
