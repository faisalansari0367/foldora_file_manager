import 'package:flutter/material.dart';


class MySnackBar {
  static final myMessengerKey = GlobalKey<ScaffoldMessengerState>();
  static void show({@required String content}) {
    final snackBar = SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: ThemeData.dark().textTheme.bodyText2,
      ),
    );
    myMessengerKey.currentState
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
