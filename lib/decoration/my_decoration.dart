import 'package:files/utilities/MyColors.dart';
import 'package:flutter/material.dart';

class MyDecoration {
  static const showMediaStorageBackground = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [MyColors.darkGrey, Colors.white],
      stops: [0.4, 0.41],
    ),
  );
}
