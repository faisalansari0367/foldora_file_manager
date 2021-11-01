import 'package:files/sizeConfig.dart';
import 'package:files/utilities/MyColors.dart';
import 'package:flutter/material.dart';

final style = ElevatedButton.styleFrom(
  elevation: 4,
  primary: MyColors.teal,
  shadowColor: MyColors.teal,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(32.0),
    side: BorderSide(color: MyColors.teal),
  ),
  minimumSize: Size(Responsive.width(87), Responsive.height(6)),
);

class MyElevatedButton extends StatelessWidget {
  final Function onPressed;
  final String text;
  const MyElevatedButton({Key key, this.onPressed, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: style,
      child: Text(
        text,
        style: TextStyle(fontSize: Responsive.textMultiplier * 1.7),
      ),
    );
  }
}
