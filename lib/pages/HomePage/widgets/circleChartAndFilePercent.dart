import 'package:files/pages/HomePage/widgets/CircleChart.dart';
import 'package:files/provider/StoragePathProvider.dart';
import 'package:files/provider/MyProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../sizeConfig.dart';
import 'FilePercent.dart';

class CircleChartAndFilePercent extends StatefulWidget {
  @override
  _CircleChartAndFilePercentState createState() =>
      _CircleChartAndFilePercentState();
}

class _CircleChartAndFilePercentState extends State<CircleChartAndFilePercent> {
  double _photosPercent = 0.0;
  double _mediaPercent = 0.0;
  double _documentsPercent = 0.0;

  @override
  Widget build(BuildContext context) {
    final storage = Provider.of<MyProvider>(context, listen: false);

    return Container(
      padding: EdgeInsets.only(
        right: 6 * Responsive.imageSizeMultiplier,
        left: 6 * Responsive.widthMultiplier,
      ),
      margin: EdgeInsets.only(
        left: 12 * Responsive.widthMultiplier,
        // right: 6 * Responsive.imageSizeMultiplier,
      ),
      child: Row(
        children: <Widget>[
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Selector<StoragePathProvider, int>(
                selector: (context, value) => value.photosSize,
                builder: (_, value, __) {
                  final totalSize = storage.calculatePercent(value, 3);
                  _photosPercent = double.parse(totalSize);
                  return CircleChart(
                    color: Colors.indigo[300],
                    strokeWidth: 6,
                    radius: Responsive.imageSize(3.5),
                    percentage: _photosPercent,
                  );
                },
              ),
              Selector<StoragePathProvider, int>(
                selector: (context, value) => value.mediaSize,
                // shouldRebuild: (a, b) => a != b,
                builder: (_, value, __) {
                  final complete = storage.calculatePercent(value, 3);
                  _mediaPercent = double.parse(complete);
                  print('mediaSize: $_mediaPercent');
                  // print(_mediaPercent);

                  return CircleChart(
                    // duration: Duration(seconds: 5),
                    strokeWidth: 5,
                    color: Colors.teal[300],
                    radius: Responsive.imageSize(2.6),
                    percentage: _mediaPercent,
                  );
                },
              ),
              Selector<StoragePathProvider, int>(
                selector: (context, value) => value.documentsSize,
                builder: (context, value, child) {
                  final documents = storage.calculatePercent(value, 3);
                  _documentsPercent = double.parse(documents);
                  // print(_documentsPercent);
                  return CircleChart(
                    strokeWidth: 4,
                    color: Colors.amber[300],
                    radius: Responsive.imageSize(1.7),
                    percentage: _documentsPercent,
                  );
                },
              ),
            ],
          ),
          Spacer(),
          Container(
            width: 42 * Responsive.widthMultiplier,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Selector<StoragePathProvider, int>(
                  selector: (context, value) => value.photosSize,
                  builder: (context, value, child) {
                    return FilePercent(
                      name: "Photos",
                      percent: "${_photosPercent.toStringAsFixed(1)}%",
                      color: Colors.teal[300],
                    );
                  },
                ),
                Selector<StoragePathProvider, int>(
                  selector: (context, value) => value.mediaSize,
                  builder: (_, value, __) {
                    return FilePercent(
                      name: "Media",
                      percent: "${_mediaPercent.toStringAsFixed(1)}%",
                      color: Colors.amber[300],
                    );
                  },
                ),
                Selector<StoragePathProvider, int>(
                  selector: (context, value) => value.documentsSize,
                  // shouldRebuild: (a, b) => true,
                  builder: (context, value, child) {
                    return FilePercent(
                      name: "Documents",
                      percent: "${_documentsPercent.toStringAsFixed(1)}%",
                      color: Colors.indigo[300],
                    );
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
