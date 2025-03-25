import 'package:flutter/material.dart';

class TitleBar extends AppBar {
  TitleBar(BuildContext context, String title, {super.key})
    : super(
        title: Text(title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      );
}
