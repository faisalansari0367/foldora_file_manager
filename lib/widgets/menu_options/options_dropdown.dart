import 'package:files/pages/Drive/my_bottom_sheet.dart';
import 'package:files/utilities/MyColors.dart';
import 'package:files/widgets/menu_options/option_item.dart';
import 'package:flutter/material.dart';

import '../my_annotated_region.dart';

class DropdownOptions extends StatelessWidget {
  /// pass the OptionItem in the children.
  final List<Widget> children;

  const DropdownOptions({Key key, this.children = const []}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
      ),
      child: IconButton(
        splashRadius: 25,
        icon: Icon(Icons.more_vert),
        color: Colors.grey[500],
        onPressed: () => MyBottomSheet.bottomSheet(
          context,
          child: MyAnnotatedRegion(
            systemNavigationBarColor: MyColors.darkGrey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: children,
            ),
          ),
        ),
      ),
    );
  }
}
