import 'package:files/utilities/MyColors.dart';
import 'package:flutter/material.dart';
import './LinearPercentBar.dart';
import '../../sizeConfig.dart';
import './ShowStorageDetails.dart';

class MediaStorageInfo extends StatelessWidget {
  final int index;
  // static const backgroundColor = Color(0xFF2c2c3c);
  const MediaStorageInfo({this.index});

  static final pageDetails = Row(
    children: <Widget>[
      Padding(
        padding: EdgeInsets.only(
          right: 3 * Responsive.widthMultiplier,
        ),
        child: Image.asset(
          "assets/video.png",
          height: 3.4 * Responsive.textMultiplier,
        ),
      ),
      Text(
        "Media",
        style: TextStyle(
          fontSize: 3.3 * Responsive.textMultiplier,
          color: Colors.white,
        ),
      ),
      const Spacer(),
    ],
  );

  @override
  Widget build(BuildContext context) {
    print('mediaStorageInfo called');
    return Container(
      color: Colors.white,
      child: Container(
        // color: MyColors.darkGrey,
        height: 0.33 * MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: MyColors.darkGrey,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(30.0),
            bottomLeft: Radius.circular(30.0),
          ),
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                right: 6 * Responsive.imageSizeMultiplier,
                top: 6 * Responsive.imageSizeMultiplier,
                left: 6 * Responsive.imageSizeMultiplier,
              ),
              child: MediaStorageInfo.pageDetails,
            ),
            Padding(
              padding: EdgeInsets.only(
                right: 6 * Responsive.imageSizeMultiplier,
                left: 6 * Responsive.imageSizeMultiplier,
                top: 10 * Responsive.imageSizeMultiplier,
              ),
              child: ShowStorageDetails(),
            ),
            LinearPercentBar(),
          ],
        ),
      ),
    );
  }
}
