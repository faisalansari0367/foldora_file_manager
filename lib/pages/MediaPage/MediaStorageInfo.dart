import 'package:files/decoration/my_decoration.dart';
import 'package:files/utilities/MyColors.dart';
import 'package:flutter/material.dart';

import './LinearPercentBar.dart';
import './ShowStorageDetails.dart';
import '../../sizeConfig.dart';

class MediaStorageInfo extends StatelessWidget {
  final String path, storageName;
  final int usedBytes, availableBytes, totalBytes;

  // static const backgroundColor = Color(0xFF2c2c3c);
  const MediaStorageInfo({
    this.path = 'assets/video.png',
    this.storageName = 'Media',
    this.usedBytes = 0,
    this.availableBytes = 0,
    this.totalBytes = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Container(
        height: Responsive.height(33),
        padding: EdgeInsets.symmetric(horizontal: 6 * Responsive.imageSizeMultiplier),
        decoration: BoxDecoration(
          color: MyColors.darkGrey,
          borderRadius: BorderRadius.only(
            bottomRight: MyDecoration.circularRadius,
            bottomLeft: MyDecoration.circularRadius,
          ),
        ),
        child: Column(
          children: <Widget>[
            SizedBox(height: Responsive.imageSize(6)),
            StorageType(path: path, storageName: storageName),
            SizedBox(height: Responsive.imageSize(10)),
            ShowStorageDetails(availableBytes: availableBytes, usedBytes: usedBytes),
            SizedBox(height: Responsive.imageSize(10)),
            LinearPercentBar(totalBytes: totalBytes, usedBytes: usedBytes),
          ],
        ),
      ),
    );
  }
}

class StorageType extends StatelessWidget {
  final String path, storageName;
  const StorageType({
    Key key,
    @required this.path,
    @required this.storageName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
            right: 3 * Responsive.widthMultiplier,
          ),
          child: Image.asset(
            path,
            height: 3.4 * Responsive.textMultiplier,
          ),
        ),
        Text(
          storageName,
          style: TextStyle(
            fontSize: 3.3 * Responsive.textMultiplier,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
