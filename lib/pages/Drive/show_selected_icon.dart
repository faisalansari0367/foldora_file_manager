import 'package:files/decoration/my_decoration.dart';
import 'package:files/utilities/MyColors.dart';
import 'package:flutter/material.dart';

import '../../sizeConfig.dart';

class ShowSelectedIcon extends StatelessWidget {
  final bool isSelected;
  final Widget child;
  const ShowSelectedIcon({
    Key? key,
    this.isSelected = false,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: MyDecoration.duration,
      child: isSelected
          ? Container(
              key: UniqueKey(),
              height: Responsive.imageSize(10),
              width: Responsive.imageSize(10),
              decoration: BoxDecoration(
                color: MyColors.darkGrey,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check,
                color: MyColors.teal,
              ),
            )
          : child,
    );
  }
}
