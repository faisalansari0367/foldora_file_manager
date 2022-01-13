import 'package:files/decoration/my_decoration.dart';
import 'package:files/pages/Drive/drive_nav_rail_item.dart';
import 'package:files/utilities/MyColors.dart';
import 'package:files/widgets/nav_rail/nav_rail_widget.dart';
import 'package:flutter/material.dart';

import '../../sizeConfig.dart';

class NavRail extends StatelessWidget {
  final List<DriveNavRailItem> data;
  final int selectedIndex;
  final void Function(DriveNavRailItem) onTap;
  const NavRail({Key key, this.data, this.selectedIndex, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final child = Container(
      color: MyColors.darkGrey,
      height: 6.height,
      child: ListView.builder(
        itemCount: data.length,
        padding: EdgeInsets.symmetric(horizontal: 5.padding),
        scrollDirection: Axis.horizontal,
        physics: MyDecoration.physics,
        itemBuilder: (context, index) {
          final item = data[index];
          return NavItem(
            isSelected: selectedIndex == index,
            path: item.name,
            onTap: () => onTap(item),
            selectedColor: MyColors.teal,
          );
        },
      ),
    );
    return child;
  }
}
