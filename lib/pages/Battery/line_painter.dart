import 'dart:async';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
// import 'math';

import 'helpers.dart';

class LiveLine extends StatefulWidget {
  const LiveLine({Key? key}) : super(key: key);

  @override
  _LiveLineState createState() => _LiveLineState();
}

class _LiveLineState extends State<LiveLine> {
  var timerForChagningMinMax;
  late var timer;
  var time = 0.0;
  var value = 500.0;
  var spots = <FlSpot>[];
  double _minX = 0;
  double _maxX = 60;
  // ignore: prefer_final_fields
  double _minY = 0;
  // ignore: prefer_final_fields
  double _maxY = 3000;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      // print(timer.tick);
      if (timer.tick > 60) {
        _minX++;
        _maxX++;
      }
      spots.add(FlSpot(timer.tick.toDouble(), value));
      if (spots.length > 60) {
        spots.removeAt(0);
      }
      value = Random().nextDouble() * 3000;
      setState(() {});
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final linechartdata = LineChartData(
      // clipData: FlClipData(top: false, bottom: false, left: true, right: true),

      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (context, value) => const TextStyle(
            color: Colors.white38,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          margin: 10,
          getTitles: getTitles,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (context, value) => const TextStyle(
            color: Color(0xff75729e),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          getTitles: (value) => '',
          margin: 10,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      gridData: FlGridData(
        horizontalInterval: 1000,
        drawHorizontalLine: false,
        drawVerticalLine: false,
        show: false,
      ),
      backgroundColor: Colors.transparent,
      minX: _minX,
      maxX: _maxX,
      minY: _minY,
      maxY: _maxY,
      lineBarsData: [
        LineChartBarData(
          shadow: Shadow(
            color: Colors.black12,
            blurRadius: 1,
            offset: Offset(10, 10),
          ),
          colors: [Colors.white],
          spots: spots,
          isCurved: true,
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
        ),
      ],
    );
    return LineChart(
      linechartdata,
      swapAnimationCurve: Curves.fastOutSlowIn,
      swapAnimationDuration: Duration(milliseconds: 1000),
    );
  }
}
