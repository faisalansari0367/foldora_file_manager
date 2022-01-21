import 'package:files/decoration/my_decoration.dart';
import 'package:files/pages/Drive/drive_list_item.dart';
import 'package:files/sizeConfig.dart';
import 'package:files/widgets/shimmer_animattion.dart';
import 'package:flutter/material.dart';

class DriveListItemPlaceholder extends StatelessWidget {
  final int itemCount;
  const DriveListItemPlaceholder({Key key, this.itemCount =10}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: MyDecoration.physics,
      itemCount: itemCount,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return DriveListItem(
          description: ShimmerAnimation(width: 25.width),
          leading: ShimmerAnimation(height: 11.image, width: 11.image),
          title: ShimmerAnimation(),
        );
      },
    );
  }
}
