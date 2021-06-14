import 'package:files/provider/MyProvider.dart';
import 'package:files/utilities/Utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../sizeConfig.dart';

class ShowStorageDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MyProvider>(context, listen: false);

    final availableSpace = Selector<MyProvider, int>(
      selector: (_, page) => page.currentPage,
      builder: (_, page, __) {
        final available =
            FileUtils.formatBytes(provider.data[page].free, 2, inGB: true);
        return Text(
          available,
          style: TextStyle(color: Colors.grey[400]),
        );
      },
    );

    final usedSpace = Selector<MyProvider, int>(
      selector: (_, page) => page.currentPage,
      builder: (_, page, __) {
        final used =
            FileUtils.formatBytes(provider.data[page].used, 2, inGB: true);
        return Text(
          used.split(' ')[0],
          style: TextStyle(
            fontSize: 6 * Responsive.textMultiplier,
            color: Colors.white,
          ),
        );
      },
    );

    return Container(
      width: 0.87 * MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _row(context, usedSpace),
          _column(context, availableSpace),
        ],
      ),
    );
  }
}

Container _column(context, available) {
  return Container(
    padding: EdgeInsets.only(right: 2.0 * Responsive.widthMultiplier),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        available,
        SizedBox(height: 0.5 * Responsive.heightMultiplier),
        Text(
          "Available",
          style: TextStyle(color: Colors.grey[400]),
        ),
      ],
    ),
  );
}

Row _row(context, used) {
  return Row(
    children: [
      used,
      Container(
        width: 0.2 * MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(
          top: 1 * Responsive.heightMultiplier,
          left: 2 * Responsive.widthMultiplier,
          bottom: 1 * Responsive.heightMultiplier,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              "GB",
              style: TextStyle(color: Colors.grey[400]),
            ),
            SizedBox(height: 0.5 * Responsive.heightMultiplier),
            Text(
              "Used",
              style: TextStyle(color: Colors.grey[400]),
            ),
          ],
        ),
      ),
    ],
  );
}
