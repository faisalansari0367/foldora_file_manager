
import 'package:files/utilities/MyColors.dart';
import 'package:flutter/material.dart';

import '../../sizeConfig.dart';
class NavItem extends StatelessWidget {
  final void Function() onTap;
  final String path;
  final Color selectedColor;
  final bool isSelected;
  const NavItem({Key key, this.path, this.isSelected, this.onTap, this.selectedColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? MyColors.teal : Colors.grey.shade400;
    return Row(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.only(
              bottom: 10,
              top: 10,
              left: 5,
              right: 5,
            ),
            child: Text(
              path,
              style: TextStyle(
                color:  color,
                fontSize: 1.7 * Responsive.textMultiplier,
              ),
            ),
          ),
        ),
        Icon(
          Icons.chevron_right,
          color: color,
        ),
      ],
    );
  }
}
