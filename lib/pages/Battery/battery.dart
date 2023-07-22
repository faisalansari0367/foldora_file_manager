import 'dart:developer';
import 'package:files/data_models/battery_manager.dart';
import 'package:flutter/material.dart';
import 'package:storage_details/storage_details.dart';

import 'helpers.dart';
import 'line_painter.dart';

class BatteryScreen extends StatefulWidget {
  BatteryScreen({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _BatteryScreenState createState() => _BatteryScreenState();
}

class _BatteryScreenState extends State<BatteryScreen> {
  static const valuesList = <String>['3000', '2500', '2000', '1500', '1000', '500'];
  static final Color backgroundColor = Color(0xff5a56e9);
  static const Radius radius = Radius.circular(25);
  var data = <BatteryManager>[];

  final background = Container(
    height: 400,
    child: Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        // color: Colors.white,
        borderRadius: BorderRadius.only(bottomLeft: radius, bottomRight: radius),
      ),
    ),
  );

  // int mahValue = 3000;

  List<Widget> chargingValues(context) {
    var position = 50.0;
    var index = 1.0;
    var widgets = <Widget>[];
    for (var item in valuesList) {
      index++;
      final value = mahValues(context, item, position * index);
      widgets.add(value);
    }
    return widgets;
  }

  @override
  void initState() {
    super.initState();
    StorageDetails.watchFilesForChanges.listen((dynamic event) {
      // data.add(event);
      final _data = BatteryManager.fromMap(event);
      data.add(_data);
      log(event.toString());
      setState(() {});
      // notifyListeners();
    });
    // NativeMethods.watchBatteryService.listen(print);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // title: Text(widget.title),
        elevation: 0.0,
        backgroundColor: backgroundColor,
        leading: Icon(Icons.arrow_back_ios),
      ),
      body: Column(
        children: [
          Stack(
            children: [
              background,
              mahValues(context, '3000', 50),
              mahValues(context, '2500', 100),
              mahValues(context, '2000', 150),
              mahValues(context, '1500', 200),
              mahValues(context, '1000', 250),
              mahValues(context, '500', 300),
              Positioned(
                right: 60,
                top: 56,
                child: Container(
                  height: 280,
                  width: 350,
                  child: LiveLine(),
                ),
              ),
            ],
          ),
          if (data.isNotEmpty) ...[
            Text('energyCounter: ${data.last.energyCounter! * 0.001}'),
            Text('chargeCounter: ${data.last.chargeCounter}'),
            Text('currentNow: ${data.last.currentNow}'),
            Text('currentAvg: ${data.last.currentAvg}'),
            Text('health: ${data.last.health}'),
            Text('battery level: ${data.last.level}'),
            Text('temperature: ${data.last.temperature}'),
            Text('voltage: ${data.last.voltage}'),
            Text('status: ${data.last.status}'),
            Text('scale: ${data.last.scale}'),
            Text('technology: ${data.last.technology}'),
          ]
        ],
      ),
    );
  }
}
