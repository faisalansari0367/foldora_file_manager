import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class LinearPercentBar extends StatelessWidget {
  final int usedBytes, totalBytes;
  const LinearPercentBar({Key key, this.usedBytes, this.totalBytes})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var percent = usedBytes / totalBytes * 100 / 100;
    final calculatePercent = percent.isNaN ? 0.0 : percent;
    return Center(
      child: LinearPercentIndicator(
        animation: true,
        curve: Curves.easeInOutBack,
        animationDuration: 1000,
        animateFromLastPercent: true,
        width: 0.87 * MediaQuery.of(context).size.width,
        lineHeight: 8.0,
        percent: calculatePercent,
        progressColor: Colors.greenAccent,
        backgroundColor: Colors.grey[700],
      ),
    );
  }
}
