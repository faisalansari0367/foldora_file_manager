import 'dart:io';

import 'package:files/provider/MyProvider.dart';
import 'package:files/provider/OperationsProvider.dart';
import 'package:files/utilities/MyColors.dart';
import 'package:files/utilities/Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

import '../sizeConfig.dart';
import 'MyDropDown.dart';
import 'Search.dart';
import 'package:path/path.dart' as p;

class AppbarUtils {
  static const duration = Duration(milliseconds: 300);
  static const splashRadius = 25.0;
  static void selectInverse(context) async {
    final myProvider = Provider.of<MyProvider>(context, listen: false);
    final operations = Provider.of<OperationsProvider>(context, listen: false);
    final path = myProvider.data[myProvider.currentPage].currentPath;
    final list = await FileUtils.worker.doWork(FileUtils.directoryList, {'path': path});
    operations.selectInverse(list);
  }

  static void selectAllFolders(context) async {
    final myProvider = Provider.of<MyProvider>(context, listen: false);
    final operations = Provider.of<OperationsProvider>(context, listen: false);

    final path = myProvider.data[myProvider.currentPage].currentPath;
    final list = await FileUtils.worker.doWork(FileUtils.directoryList, {'path': path});
    operations.selectAll(list);
    // for (var item in list) {
    //   operations.onTapOfLeading(item);
    //   // print(operations.selectedMedia.length);
    // }
    // myProvider.notify();
  }

  static List<Widget> appbarActions(BuildContext context, bool showOther) {
    final actionsOnSelectedMedia = [
      IconButton(
        icon: Icon(Icons.select_all),
        tooltip: 'Select All',
        onPressed: () => selectAllFolders(context),
      ),
      IconButton(
        icon: Icon(Icons.copy_all),
        onPressed: () => selectInverse(context),
      )
    ];
    final currentActions = [
      AnimatedSwitcher(
        duration: duration,
        child: showOther ? actionsOnSelectedMedia.first : searchIcon(context),
      ),
      AnimatedSwitcher(
        duration: duration,
        child: showOther ? actionsOnSelectedMedia.last : MyDropDown(),
      ),
      // MyDropDown()
    ];

    return AnimationConfiguration.toStaggeredList(
      duration: const Duration(milliseconds: 400),
      childAnimationBuilder: (widget) => FadeInAnimation(
        key: UniqueKey(),
        delay: Duration(milliseconds: 80),
        child: widget,
      ),
      children: showOther ? actionsOnSelectedMedia : currentActions,
    );

    // ,
    // return showOther ? actionsOnSelectedMedia : currentActions;
  }

  static SystemUiOverlayStyle systemUiOverylay({
    Color backgroundColor,
    Brightness brightness = Brightness.light,
    Color systemNavigationBarColor,
  }) {
    return SystemUiOverlayStyle(
      statusBarBrightness: brightness,
      statusBarIconBrightness: brightness,
      systemNavigationBarColor: systemNavigationBarColor ?? Colors.transparent,
      statusBarColor: backgroundColor ?? Colors.transparent,
      systemNavigationBarContrastEnforced: true,
      systemNavigationBarDividerColor: Colors.transparent,
      systemStatusBarContrastEnforced: true,
      systemNavigationBarIconBrightness: brightness,
    );
  }

  static IconButton searchIcon(BuildContext context) {
    return AppbarUtils.icon(
      context,
      Icon(Icons.search),
      () async => await showSearch(
        context: context,
        delegate: Search(),
      ),
    );
  }

  static IconButton backIcon(BuildContext context) {
    return AppbarUtils.icon(
      context,
      Icon(Icons.arrow_back),
      () => Navigator.pop(context),
    );
  }

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
  final Color backgroundColor, systemNavbarColor;
  final IconData iconData;
  final bool menu;
  final bool bottomNavBar;
  final Widget bottom, title;
  final Brightness brightness;
  final List<Widget> actions;
  // final StorageType storageType;
  const MyAppBar({
    this.backgroundColor,
    this.iconData,
    this.menu,
    this.bottomNavBar = false,
    this.bottom,
    this.brightness = Brightness.light,
    this.actions,
    this.title,
    this.systemNavbarColor = Colors.transparent,
  });

  @override
  Size get preferredSize => Size.fromHeight((bottomNavBar ? 12.36 : 6.36) * Responsive.heightMultiplier);

  @override
  Widget build(BuildContext context) {
    final color = backgroundColor ?? MyColors.darkGrey;
    return AppBar(
      systemOverlayStyle:
          AppbarUtils.systemUiOverylay(brightness: brightness, systemNavigationBarColor: systemNavbarColor),
      backgroundColor: color,
      leading: AppbarUtils.backIcon(context),
      elevation: 0.0,
      actions: actions ?? [AppbarUtils.searchIcon(context), MyDropDown()],
      bottom: bottom,
      title: title,
      // bottom: bottomNavBar ? MyBottomAppBar() : null,
    );
  }
}
