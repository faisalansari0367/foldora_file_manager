// import 'package:files/pages/Drive/sign_in_screen.dart';
import 'package:files/decoration/my_decoration.dart';
import 'package:flutter/material.dart';

import '../../../../sizeConfig.dart';
import 'drive_tab.dart';
import 'media_tab.dart';
import 'photos_tab.dart';
import 'videos_tab.dart';

class HorizontalTabs extends StatefulWidget {
  @override
  State<HorizontalTabs> createState() => _HorizontalTabsState();
}

class _HorizontalTabsState extends State<HorizontalTabs> {
  static final children = <Widget>[PhotosTab(), MediaTab(), VideosTab(), DriveTab()];
  static final sizedBox = SizedBox(width: 5.width);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40 * Responsive.heightMultiplier,
      child: ListView.separated(
        itemCount: children.length,
        padding: EdgeInsets.symmetric(horizontal: 5.width),
        scrollDirection: Axis.horizontal,
        physics: MyDecoration.physics,
        itemBuilder: itemBuilder,
        separatorBuilder: seperatorBuilder,
      ),
    );
  }

  Widget seperatorBuilder(context, index) => sizedBox;
  Widget itemBuilder(context, index) => children[index];

  // @override
  // bool get wantKeepAlive => true;
}
