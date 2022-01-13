import 'package:files/utilities/MyColors.dart';
import 'package:flutter/material.dart';

import '../sizeConfig.dart';

class MyDecoration {
  static const Radius circularRadius = Radius.circular(25);
  static const BorderRadius borderRadius = BorderRadius.all(circularRadius);
  static const BouncingScrollPhysics physics = BouncingScrollPhysics();
  static const Curve curve = Curves.fastOutSlowIn;
  // static const radius = Radius.circular(25);
  // static final borderRadius = BorderRadius.circular(25.0);

  static const BorderRadius borderRadiusTlr = BorderRadius.only(
    topLeft: circularRadius,
    topRight: circularRadius,
  );

  static const showMediaStorageBackground = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [MyColors.darkGrey, Colors.white],
      stops: [0.4, 0.1],
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

  static const duration = Duration(milliseconds: 375);

  static final elevatedButtonStyle = ElevatedButton.styleFrom(
    elevation: 4,
    primary: MyColors.teal,
    shadowColor: MyColors.teal,
    shape: roundedBorderShape,
    minimumSize: Size(Responsive.width(87), Responsive.height(5)),
  );

  static BoxDecoration decoration({Color color = Colors.white}) {
    return BoxDecoration(
      color: color,
      borderRadius: borderRadius,
    );
  }

  static Widget bottomSheetTopIndicator({Color color, double heightFactor}) {
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
