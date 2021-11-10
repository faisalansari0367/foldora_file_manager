import 'package:files/utilities/Utils.dart';
import 'package:flutter/material.dart';

import '../../sizeConfig.dart';

class ShowStorageDetails extends StatelessWidget {
  final int usedBytes, availableBytes;

  const ShowStorageDetails({Key key, this.usedBytes, this.availableBytes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final provider = Provider.of<MyProvider>(context, listen: false);

    // final availableSpace = Selector<MyProvider, int>(
    //   selector: (_, page) => page.currentPage,
    //   builder: (_, page, __) {
    //     final available = FileUtils.formatBytes(provider.data[page].free, 2, inGB: true);
    //     return Text(
    //       available,
    //       style: TextStyle(color: Colors.grey[400]),
    //     );
    //   },
    // );

    // final usedSpace = Selector<MyProvider, int>(
    //   selector: (_, page) => page.currentPage,
    //   builder: (_, page, __) {
    //     final used = FileUtils.formatBytes(provider.data[page].used, 2, inGB: true);
    //     return Text(
    //       used.split(' ')[0],
    //       style: TextStyle(
    //         fontSize: 6 * Responsive.textMultiplier,
    //         color: Colors.white,
    //       ),
    //     );
    //   },
    // );

    return Container(
      width: 0.87 * MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          UsedSpace(usedBytes: usedBytes),
          AvailableSpace(availableBytes: availableBytes),
        ],
      ),
    );
  }
}

class AvailableSpace extends StatelessWidget {
  final int availableBytes;
  const AvailableSpace({Key key, this.availableBytes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final available = FileUtils.formatBytes(availableBytes, 2, inGB: true);
    return Container(
      padding: EdgeInsets.only(right: 2.0 * Responsive.widthMultiplier),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Text(
            available,
            style: TextStyle(color: Colors.grey[400]),
          ),
          SizedBox(height: 0.5 * Responsive.heightMultiplier),
          Text(
            'Available',
            style: TextStyle(color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }
}

class UsedSpace extends StatelessWidget {
  final int usedBytes;
  const UsedSpace({Key key, this.usedBytes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final used = FileUtils.formatBytes(usedBytes, 2, inGB: true);
    return Row(
      children: [
        Text(
          used.split(' ')[0],
          style: TextStyle(
            fontSize: 6 * Responsive.textMultiplier,
            color: Colors.white,
          ),
        ),
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
                'GB',
                style: TextStyle(color: Colors.grey[400]),
              ),
              SizedBox(height: 0.5 * Responsive.heightMultiplier),
              Text(
                'Used',
                style: TextStyle(color: Colors.grey[400]),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
