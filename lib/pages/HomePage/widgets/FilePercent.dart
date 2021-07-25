import 'package:flutter/material.dart';
import '../../../sizeConfig.dart';

class FilePercent extends StatelessWidget {
  final Color color;
  final String percent;
  final String name;
  final Future future;

  const FilePercent({this.color, this.percent, this.name, this.future});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(3 * Responsive.imageSizeMultiplier),
          child: Column(
            children: <Widget>[
              CircleAvatar(
                backgroundColor: color,
                radius: 1 * Responsive.imageSizeMultiplier,
              ),
            ],
          ),
        ),
        Text(
          name,
          style: TextStyle(
            color: Colors.grey[600],
            fontWeight: FontWeight.w400,
          ),
        ),
        Spacer(),
        Text(
          percent,
          style: TextStyle(
            color: Colors.grey[600],
            letterSpacing: 0.25,
            fontWeight: FontWeight.w600,
          ),
        )
      ],
    );
  }
}
