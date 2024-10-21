import 'dart:io';

void clearConsole() {
  //https://stackoverflow.com/questions/21269769/clearing-the-terminal-screen-in-a-command-line-dart-app
  stdout.write('\x1B[2J\x1B[0;0H');
}

int? choice() {
  // get user input for choice
  print('Enter choice: ');
  var choice = int.tryParse(stdin.readLineSync()!);
  return choice;
}
