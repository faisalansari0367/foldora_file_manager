import 'package:flutter/material.dart';

Widget mahValues(BuildContext context, String values, double top) {
  final screenSize = MediaQuery.of(context).size;
  return Positioned(
    top: top ?? 0,
    child: Container(
      width: screenSize.width,
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: screenSize.width * 0.85,
            height: 0.2,
            color: Colors.white54,
          ),
          SizedBox(width: 10),
          Text(
            values,
            style: TextStyle(color: Colors.white38),
          ),
        ],
      ),
    ),
  );
}

String getTitles(double value) {
  switch (value.toInt()) {
    case 0:
      return '0';
    case 10:
      return '10';
    case 20:
      return '20';
    case 30:
      return '30';
    case 40:
      return '40';
    case 50:
      return '50';
    case 60:
      return '60';
      return '';
  }
  return '';
}
