import 'package:flutter/material.dart';

class MyColors {
  static const appbarActionsSize = 25.0,
      darkGrey = Color(0xff28293b),
      shadeGrey = Color(0xff2e2f42),
      white = Colors.white,
      whitish = Color(0xfffcfcff),
      teal = Color(0xff5ace99);
  // 0xff5ace99
  static final appbarActionsColor = Colors.grey[500];
  static final primaryText = Colors.grey[400];
  static final dropdownText = Colors.grey[300];

  //
  static final themeData = ThemeData(
    appBarTheme: AppBarTheme(
      actionsIconTheme: IconThemeData(
        color: appbarActionsColor,
        opacity: 1,
        size: appbarActionsSize,
      ),
    ),
    colorScheme: ColorScheme.light().copyWith(primary: teal),
  );
}
