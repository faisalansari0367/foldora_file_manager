import 'package:flutter/material.dart';

import '../../sizeConfig.dart';

class MediaFiles extends StatelessWidget {
  final String filesName;
  final Widget menu;

  const MediaFiles({Key key, this.filesName = 'Media Files', this.menu}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
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
            filesName,
            style: TextStyle(
              fontSize: 3.4 * Responsive.textMultiplier,
            ),
          ),
          Spacer(),
          if (menu != null) menu,
        ],
      ),
    );
  }
}
