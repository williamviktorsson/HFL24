import 'package:flutter/material.dart';

class ExampleView extends StatelessWidget {
  const ExampleView({super.key, required this.foobar});

  final int foobar;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Example view $foobar"));
  }
}
