import 'dart:io';

import 'package:files/utilities/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../sizeConfig.dart';
import 'MyDropDown.dart';
import 'Search.dart';
import 'package:path/path.dart' as p;

class AppbarUtils {
  static const duration = Duration(milliseconds: 100);

  static const splashRadius = 25.0;
  static IconButton icon(BuildContext context, Icon icon, Function onPressed) {
    return IconButton(
      splashRadius: splashRadius,
      color: Colors.grey[500],
      icon: icon,
      onPressed: onPressed,
    );
  }

  static Widget navigator(Function ontap, String path) {
    return Row(
      children: [
        InkWell(
          onTap: () => ontap(Directory(path)),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.only(
              bottom: 10,
              top: 10,
              left: 5,
              right: 5,
            ),
            child: Text(
              p.basename(path).toUpperCase(),
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 1.7 * Responsive.textMultiplier,
              ),
            ),
          ),
        ),
        Icon(
          Icons.chevron_right,
          color: Colors.grey[400],
        ),
      ],
    );
  }
}

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color backgroundColor;
  final IconData iconData;
  final bool menu;
  final bool bottomNavBar;
  // final StorageType storageType;
  const MyAppBar({
    this.backgroundColor,
    this.iconData,
    this.menu,
    this.bottomNavBar = false,
  });

  @override
  Size get preferredSize => Size.fromHeight(
      (bottomNavBar ? 12.36 : 6.36) * Responsive.heightMultiplier);

  @override
  Widget build(BuildContext context) {
    final pop = () => Navigator.pop(context);
    final showSearchFunction = () async => await showSearch(
          context: context,
          delegate: Search(),
        );
    final actions = [
      AppbarUtils.icon(context, Icon(Icons.search), showSearchFunction),
      MyDropDown()
    ];

    return AppBar(
      backgroundColor: backgroundColor ?? MyColors.darkGrey,
      leading: AppbarUtils.icon(context, Icon(Icons.arrow_back), pop),
      elevation: 0.0,
      actions: actions,
      // bottom: bottomNavBar ? MyBottomAppBar() : null,
    );
  }
}
