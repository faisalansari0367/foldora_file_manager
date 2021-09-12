import 'package:files/sizeConfig.dart';
import 'package:flutter/material.dart';

class MyTabController extends StatefulWidget with PreferredSizeWidget {
  const MyTabController();

  @override
  _MyTabControllerState createState() => _MyTabControllerState();

  @override
  Size get preferredSize => Size.fromHeight(Responsive.height(6 * 2.0));
}

class _MyTabControllerState extends State<MyTabController> with SingleTickerProviderStateMixin {
  TabController tabController;
  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: tabController,
      isScrollable: true,
      tabs: [
        Tab(
          icon: Icon(Icons.directions_car),
        ),
        // Tab(icon: Icon(Icons.directions_transit)),
        Tab(icon: Icon(Icons.directions_bike)),
      ],
    );
  }
}
