// import 'package:files/pages/Drive/sign_in_screen.dart';
import 'package:flutter/material.dart';

import '../../../../sizeConfig.dart';
import 'drive_tab.dart';
import 'videos_tab.dart';
import 'media_tab.dart';
import 'photos_tab.dart';

// enum StorageType { INTERNAL, REMOVABLE, OTG }

class HorizontalTabs extends StatefulWidget {
  @override
  State<HorizontalTabs> createState() => _HorizontalTabsState();
}

class _HorizontalTabsState extends State<HorizontalTabs> with AutomaticKeepAliveClientMixin {
  static final Widget sizedBox = SizedBox(width: 5.width);

  static final children = <Widget>[PhotosTab(), sizedBox, MediaTab(), sizedBox, VideosTab(), sizedBox, DriveTab()];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      height: 40 * Responsive.heightMultiplier,
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 5.width),
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        children: children,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
