import 'package:files/provider/MyProvider.dart';
import 'package:files/provider/OperationsProvider.dart';
import 'package:files/sizeConfig.dart';
import 'package:files/utilities/MyColors.dart';
import 'package:files/widgets/MyAppBar.dart';
import 'package:files/widgets/MyDropDown.dart';
import 'package:files/widgets/Search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MySliverAppBar extends StatefulWidget {
  @override
  _MySliverAppBarState createState() => _MySliverAppBarState();
}

class _MySliverAppBarState extends State<MySliverAppBar> {
  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: CustomAppbar(),
    );
  }
}

class CustomAppbar extends SliverPersistentHeaderDelegate {
  final position = Tween<Offset>(begin: Offset(0, -0.5), end: Offset(0.0, 0.0));
  final reversePosition =
      Tween<Offset>(begin: Offset(0.0, 0.0), end: Offset(0.0, 1.0));

  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final column = Column(
      children: [
        Row(
          children: [
            AppbarUtils.icon(
              context,
              const Icon(Icons.arrow_back),
              () => Navigator.pop(context),
            ),
            Spacer(),
            AppbarUtils.icon(
              context,
              Icon(Icons.search),
              () async => await showSearch(
                context: context,
                delegate: Search(),
              ),
            ),
            MyDropDown(),
          ],
        ),
        Selector<Operations, bool>(
          selector: (context, value) => value.navRail,
          builder: (context, value, child) {
            return AnimatedSwitcher(
              duration: AppbarUtils.duration,
              child: value ? MyBottomAppBar() : Container(height: 0, width: 0),
              transitionBuilder: (child, animation) {
                return SlideTransition(
                  position: position.animate(animation),
                  child: child,
                );
              },
            );
          },
        ),
      ],
    );

    // final selector = Selector<Operations, double>(
    //   selector: (_, provider) => provider.appbarSize,
    //   builder: (context, value, child) {
    //     return AnimatedContainer(
    //       height: value + shrinkOffset,
    //       duration: AppbarUtils.duration,
    //       color: MyColors.darkGrey,
    //       // duration: AppbarUtils.duration,
    //       child: column,
    //     );
    //   },
    //   // child: column,
    // );

    return Container(child: column, height: 12 * Responsive.heightMultiplier);
  }

  @override
  double get maxExtent => 12 * Responsive.heightMultiplier;

  @override
  double get minExtent => 6 * Responsive.heightMultiplier;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

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
