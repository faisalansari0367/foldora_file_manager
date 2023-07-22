import 'package:cached_network_image/cached_network_image.dart';
import 'package:files/sizeConfig.dart';
import 'package:files/utilities/MyColors.dart';
import 'package:flutter/material.dart';

class ProfilePicture extends StatelessWidget {
  final String? imageUrl;
  const ProfilePicture({Key? key, this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final icon = Icon(
      Icons.account_circle_outlined,
      size: 7.padding,
      color: MyColors.appbarActionsColor,
    );
    if (imageUrl == null) return icon;
    return Container(
      clipBehavior: Clip.antiAlias,
      height: 8.padding,
      width: 8.padding,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: CachedNetworkImage(imageUrl: imageUrl!),
    );
  }
}
