import 'package:files/utilities/MyColors.dart';
import 'package:flutter/material.dart';

import '../sizeConfig.dart';

class MyDecoration {
  static const circularRadius = Radius.circular(32),
      bottomSheetCorner = Radius.circular(32),
      duration = Duration(milliseconds: 375),
      borderRadius = BorderRadius.all(circularRadius),
      physics = BouncingScrollPhysics(),
      curve = Curves.fastOutSlowIn;


  static const borderRadiusTlr = BorderRadius.vertical(top: bottomSheetCorner);

  static const showMediaStorageBackground = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [MyColors.darkGrey, Colors.transparent],
      stops: [0.3, 0.4],
    ),
  );

  static const inputBorder = OutlineInputBorder(
    borderRadius: borderRadius,
    borderSide: BorderSide(color: Colors.transparent),
  );

  static const roundedBorderShape = RoundedRectangleBorder(
    borderRadius: borderRadius,
    side: BorderSide(color: Colors.transparent),
  );

  static final elevatedButtonStyle = ElevatedButton.styleFrom(
    elevation: 4,
    primary: MyColors.teal,
    shadowColor: MyColors.teal,
    shape: roundedBorderShape,
    minimumSize: Size(87.width, 5.height),
  );

  static BoxDecoration decoration({Color color = Colors.white}) {
    return BoxDecoration(
      color: color,
      borderRadius: borderRadius,
    );
  }

  static Widget bottomSheetTopIndicator({Color? color, double? heightFactor}) {
    return Center(
      heightFactor: heightFactor,
      child: Container(
        height: 1.padding,
        width: 10.width,
        decoration: BoxDecoration(
          color: color ?? Colors.grey[300],
          borderRadius: borderRadius,
        ),
      ),
    );
  }

  static BoxDecoration bottomSheetDecoration(context) {
    return BoxDecoration(
      color: MyColors.darkGrey,
      borderRadius: borderRadiusTlr,
      boxShadow: [
        BoxShadow(
          color: Theme.of(context).shadowColor.withOpacity(0.3),
          blurRadius: 10,
          spreadRadius: 0.1,
        ),
      ],
    );
  }
}
