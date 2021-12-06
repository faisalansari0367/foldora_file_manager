import 'package:files/utilities/MyColors.dart';
import 'package:flutter/material.dart';

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
    borderRadius: BorderRadius.all(Radius.circular(50)),
    borderSide: BorderSide(color: Colors.transparent),
  );

  static const duration = Duration(milliseconds: 375);

  static BoxDecoration decoration({Color color = Colors.white}) {
    return BoxDecoration(
      color: color,
      borderRadius: borderRadius,
    );
  }

  static Widget bottomSheetTopIndicator({Color color}) {
    return Center(
      child: Container(
        height: 4,
        width: 30,
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
