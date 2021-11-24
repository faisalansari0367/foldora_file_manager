import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..removeCurrentSnackBar
      ..showSnackBar(snackBar);
  }
}
