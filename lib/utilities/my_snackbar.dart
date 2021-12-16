import 'package:flutter/material.dart';

import 'MyColors.dart';

class MySnackBar {
  static void show(BuildContext context, {@required String content}) {
    final snackBar = SnackBar(
      backgroundColor: MyColors.darkGrey,
      content: Text(
        content,
        style: TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;
    messenger
      ..removeCurrentSnackBar
      ..showSnackBar(snackBar);
  }
}
