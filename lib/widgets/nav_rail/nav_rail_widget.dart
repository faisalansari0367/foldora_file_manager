import 'package:files/widgets/animated_widgets/my_slide_animation.dart';
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
    final color = isSelected ? selectedColor : Colors.grey.shade400;
    return MySlideAnimation(
      horizontalOffset: 50,
      verticalOffset: 0,
      child: Row(
        children: [
          GestureDetector(
            onTap: onTap,
            child: AnimatedContainer(
              duration: Duration(seconds: 2),
              padding: EdgeInsets.symmetric(
                horizontal: 1.padding,
                vertical: 2.padding,
              ),
              child: Text(
                path,
                style: TextStyle(
                  color: color,
                  fontSize: 1.7.text,
                ),
              ),
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: color,
          ),
        ],
      ),
    );
  }
}
