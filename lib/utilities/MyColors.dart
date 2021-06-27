import 'dart:ui';

import 'package:flutter/material.dart';

class MyColors {
  static const appbarActionsSize = 25.0;
  // static const darkGrey = const Color(0XFF2C2C3C);
  static const darkGrey = const Color(0xff28293b);
  static const white = Colors.white;
  static const whitish = const Color(0xfffcfcff);
  static final appbarActionsColor = Colors.grey[500];
  // 0xff5ace99
  static final teal = const Color(0xff5ace99);
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
  );
}
