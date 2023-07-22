import 'package:files/helpers/provider_helpers.dart';
import 'package:files/pages/HomePage/widgets/circleChartAndFilePercent.dart';
import 'package:files/pages/HomePage/widgets/horizontal_tabs/horizontal_tabs.dart';
import 'package:files/provider/storage_path_provider.dart';
import 'package:files/provider/videos_provider.dart';
import 'package:files/utilities/MyColors.dart';
import 'package:files/widgets/FloatingActionButton.dart';
import 'package:files/widgets/MyAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../sizeConfig.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> _onRefresh(context) async {
    await getProvider<VideosProvider>(context).getVideos();
    await getProvider<StoragePathProvider>(context).onRefresh();
  }

  var sizedBox = SizedBox(height: 4.height);
  @override
  Widget build(BuildContext context) {
    final children = <Widget>[
      Padding(
        padding: EdgeInsets.only(
          left: 6 * Responsive.widthMultiplier,
          right: 6 * Responsive.imageSizeMultiplier,
        ),
        child: bigText(
          title: 'My Files',
          color: Colors.grey[500],
          height: 6,
          // iconName: Icons.more_horiz,
        ),
      ),
      sizedBox,
      CircleChartAndFilePercent(),
      sizedBox,
      HorizontalTabs(),
      sizedBox,
      Padding(
        padding: EdgeInsets.only(
          right: Responsive.width(6),
          left: Responsive.width(6),
          bottom: Responsive.height(2),
        ),
        child: bigText(
          height: 1,
          title: 'Latest Files',
          iconName: Icons.more_horiz,
          color: Colors.grey[500],
        ),
      ),
    ];

    return Scaffold(
      floatingActionButton: FAB(),
      appBar: MyAppBar(
        leading: Icon(
          Icons.menu,
          color: MyColors.appbarActionsColor,
        ),
        actions: [
          // ProfilePicture(
          //   imageUrl: Auth.getCurrentUser()?.photoURL,
          // ),
          // Icon(
          //   Icons.account_circle_outlined,
          //   size: 7.padding,
          //   color: MyColors.appbarActionsColor,
          // ),
          SizedBox(width: 3.padding),
        ],
        backgroundColor: Colors.white,
        systemNavbarColor: Colors.white,
        iconData: Icons.menu,
        bottomNavBar: false,
        brightness: Brightness.dark,
      ),
      body: Container(
        color: Colors.white,
        child: RefreshIndicator(
          onRefresh: () => _onRefresh(context),
          child: ListView(
            physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 400),
              childAnimationBuilder: (widget) => SlideAnimation(
                horizontalOffset: 50.0,
                child: FadeInAnimation(
                  delay: Duration(milliseconds: 80),
                  child: widget,
                ),
              ),
              children: children,
            ),
          ),
        ),
      ),
    );
  }
}

Widget bigText({required height, required title, iconName, color}) {
  return Row(
    children: <Widget>[
      SizedBox(
        height: height * Responsive.heightMultiplier,
      ),
      Text(
        title,
        style: TextStyle(fontSize: 3.4 * Responsive.textMultiplier),
      ),
      Spacer(),
      if (iconName != null)
        Icon(
          Icons.more_horiz,
          size: 6 * Responsive.imageSizeMultiplier,
          color: color,
        )
      else
        Container(height: 0, width: 0),
    ],
  );
}
