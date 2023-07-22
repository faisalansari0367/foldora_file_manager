import 'package:files/decoration/my_decoration.dart';
import 'package:files/sizeConfig.dart';
import 'package:files/utilities/MyColors.dart';
import 'package:files/widgets/menu_options/option_with_icon_widget.dart';
import 'package:files/widgets/my_annotated_region.dart';
import 'package:flutter/material.dart';

class MyBottomSheet {
  static Future<void> bottomSheet(
    BuildContext context, {
    Widget? child,
    AnimationController? controller,
  }) async {
    await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      transitionAnimationController: controller,
      
      enableDrag: true,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return MyAnnotatedRegion(
          systemNavigationBarColor: MyColors.darkGrey,
          child: Container(
            padding: MediaQuery.of(context).viewInsets,
            decoration: MyDecoration.bottomSheetDecoration(context),
            child: child,
          ),
        );
      },
    );
  }

  static Future<void> options(context, List<OptionIcon> children) async {
    await MyBottomSheet.bottomSheet(
      context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 3.height),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: children,
          ),
          SizedBox(height: 3.height),
        ],
      ),
    );
  }
}
