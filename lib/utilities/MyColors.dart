import 'dart:ui';

import 'package:flutter/material.dart';

class MyColors {
  static final themeData = ThemeData(
    appBarTheme: AppBarTheme(
      actionsIconTheme: IconThemeData(
        color: appbarActionsColor,
        opacity: 1,
        size: appbarActionsSize,
      ),
    ),
  );

  static const darkGrey = const Color(0XFF2C2C3C);
  static const white = Colors.white;
  static const double appbarActionsSize = 25.0;
  static final appbarActionsColor = Colors.grey[500];
}
