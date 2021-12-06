import 'package:files/pages/Drive/drive_nav_rail_item.dart';
import 'package:files/provider/drive_provider.dart';
import 'package:files/utilities/MyColors.dart';
import 'package:files/widgets/nav_rail/nav_rail_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../sizeConfig.dart';

class NavRail extends StatelessWidget {
  final List<DriveNavRailItem> data;
  final int selectedIndex;
  final void Function() onTap;
  const NavRail({Key key, this.data, this.selectedIndex, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final driveProvider = Provider.of<DriveProvider>(context, listen: false);

    final child = Container(
      color: MyColors.darkGrey,
      height: 6 * Responsive.heightMultiplier,
      child: ListView.builder(
        itemCount: data.length,
        padding: EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final item = data[index];
          return NavItem(
            isSelected: selectedIndex == index,
            path: item.name,
            onTap: () {
              driveProvider.setSelectedIndex(index);
              return driveProvider.getDriveFiles(fileId: item.id);
            },
            selectedColor: MyColors.teal,
          );
        },
      ),
    );
    return child;
  }
}
