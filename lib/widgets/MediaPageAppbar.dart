import 'package:files/provider/MyProvider.dart';
import 'package:files/utilities/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../sizeConfig.dart';
import 'MyAppBar.dart';

class MyBottomAppBar extends StatefulWidget {
  final Color backgroundColor;
  final double height;
  MyBottomAppBar({this.backgroundColor, this.height});

  @override
  _MyBottomAppBarState createState() => _MyBottomAppBarState();
}

class _MyBottomAppBarState extends State<MyBottomAppBar> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MyProvider>(context, listen: true);
    var list = provider.getListOfNavigation() ?? [];
    final child = Container(
      color: widget.backgroundColor ?? MyColors.darkGrey,
      height: widget.height ?? 6 * Responsive.heightMultiplier,
      child: ListView.builder(
        itemCount: list.length,
        padding: EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return AppbarUtils.navigator(provider.ontap, list[index]);
        },
      ),
    );
    return child;
  }
}
