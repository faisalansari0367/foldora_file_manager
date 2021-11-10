import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MySnackBar {
  static void show(BuildContext context, {@required String content}) {
    final snackBar = SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar
      ..showSnackBar(snackBar);
  }
}
