import 'dart:ui';

import 'package:files/provider/scroll_provider.dart';
import 'package:files/utilities/MyColors.dart';
import 'package:files/widgets/MediaPageAppbar.dart';
import 'package:files/widgets/MyAppBar.dart';
import 'package:files/widgets/MyDropDown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

import '../../sizeConfig.dart';

class MySliverAppBar extends StatefulWidget {
  @override
  _MySliverAppBarState createState() => _MySliverAppBarState();
}

class _MySliverAppBarState extends State<MySliverAppBar> {
  static const duration = Duration(milliseconds: 500);

  final bottom = AnimationConfiguration.synchronized(
    duration: duration,
    child: FadeInAnimation(
      delay: duration,
      child: SlideAnimation(
        verticalOffset: -50,
        child: MyBottomAppBar(
          backgroundColor: Colors.transparent,
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Selector<ScrollProvider, double>(
      selector: (context, value) => value.appbarSize,
      builder: (context, value, child) {
        return SliverAppBar(
          systemOverlayStyle: AppbarUtils.systemUiOverylay(),
          pinned: true,
          backgroundColor: MyColors.darkGrey,
          leading: AppbarUtils.backIcon(context),
          actions: [AppbarUtils.searchIcon(context), MyDropDown()],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(value),
            // child: value != Responsive.height(6) ? SizedBox() : bottom,
            child: value != Responsive.height(6) ? SizedBox() : bottom,
          ),
        );
      },
    );
  }
}
