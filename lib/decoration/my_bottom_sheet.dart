import 'package:files/decoration/my_decoration.dart';
import 'package:files/utilities/MyColors.dart';
import 'package:files/widgets/my_annotated_region.dart';
import 'package:flutter/material.dart';

class MyBottomSheet {
  static Future<void> bottomSheet(
    BuildContext context, {
    Widget child,
    AnimationController controller,
  }) async {
    await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      enableDrag: true,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return MyAnnotatedRegion(
          systemNavigationBarColor: MyColors.darkGrey,
          child: Container(
            decoration: MyDecoration.bottomSheetDecoration(context),
            child: child,
          ),
        );
      },
    );
  }
}
