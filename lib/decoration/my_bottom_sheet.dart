import 'package:files/decoration/my_decoration.dart';
import 'package:flutter/material.dart';

class MyBottomSheet {
  static Future<void> bottomSheet(BuildContext context, {Widget child, AnimationController controller}) async {
    await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      enableDrag: true,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Container(
          decoration: MyDecoration.bottomSheetDecoration(context),
          child: child,
        );
      },
    );
  }
}
