import 'package:files/utilities/MyColors.dart';
import 'package:flutter/material.dart';

import '../../sizeConfig.dart';

class MediaFiles extends StatelessWidget {
  const MediaFiles({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyColors.white,
      padding: EdgeInsets.only(
        top: 2 * Responsive.heightMultiplier,
        bottom: 1 * Responsive.heightMultiplier,
        left: 6 * Responsive.imageSizeMultiplier,
        right: 6 * Responsive.imageSizeMultiplier,
      ),
      child: Row(
        children: <Widget>[
          SizedBox(height: 6 * Responsive.heightMultiplier),
          Text(
            "Media Files",
            style: TextStyle(
              fontSize: 3.4 * Responsive.textMultiplier,
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
