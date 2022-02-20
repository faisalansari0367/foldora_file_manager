import 'package:files/decoration/my_decoration.dart';
import 'package:files/sizeConfig.dart';
import 'package:flutter/material.dart';

class MyElevatedButton extends StatelessWidget {
  final void Function() onPressed;
  final String text;
  final Widget icon;
  const MyElevatedButton({
    Key key,
    this.onPressed,
    this.text,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: MyDecoration.elevatedButtonStyle,
      child: Row(
        // mainAxisAlignment: Main,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: TextStyle(fontSize: 1.7.text),
          ),
          if (icon != null) SizedBox(width: 1.5.padding),
          if (icon != null) icon
        ],
      ),
    );
  }
}
