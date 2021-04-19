import 'package:files/provider/MyProvider.dart';
import 'package:files/sizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

class LinearPercentBar extends StatelessWidget {
  // final Storage storage;
  const LinearPercentBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MyProvider>(context, listen: true),
        storage = provider.spaceInfo[provider.currentPage],
        calculatePercent = storage.used / storage.total * 100;

    Widget child = Padding(
      padding: EdgeInsets.only(
        right: 6 * Responsive.imageSizeMultiplier,
        left: 6 * Responsive.imageSizeMultiplier,
        top: 10 * Responsive.imageSizeMultiplier,
      ),
      child: Center(
        child: LinearPercentIndicator(
          width: 0.87 * MediaQuery.of(context).size.width,
          lineHeight: 8.0,
          percent: calculatePercent / 100,
          progressColor: Colors.greenAccent,
          backgroundColor: Colors.grey[700],
        ),
      ),
    );

    return child;
  }
}
