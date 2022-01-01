import 'package:files/decoration/my_decoration.dart';
import 'package:files/sizeConfig.dart';
import 'package:flutter/material.dart';



class MyElevatedButton extends StatelessWidget {
  final Function onPressed;
  final String text;
  const MyElevatedButton({
    Key key,
    this.onPressed,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: MyDecoration.elevatedButtonStyle,
      child: Text(
        text,
        style: TextStyle(fontSize: 1.7.text),
      ),
    );
  }
}
