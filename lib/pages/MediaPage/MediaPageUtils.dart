import 'package:files/provider/MyProvider.dart';
import 'package:files/utilities/Utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storage_details/storage_details.dart';

class MediaPageUtils {
  static final usedSpace = Selector<MyProvider, int>(
    selector: (context, value) => value.spaceInfo[value.currentPage].used,
    builder: (context, value, child) {
      final used = FileUtils.formatBytes(value, 2, inGB: true).split(' ')[0];
      return Text(
        used,
        style: TextStyle(color: Colors.grey[400]),
      );
    },
  );

  static final availableSpace = Selector<MyProvider, Storage>(
    selector: (context, value) => value.spaceInfo[value.currentPage],
    builder: (context, value, child) {
      final available = FileUtils.formatBytes(value.free, 2);
      return Text(
        available,
        style: TextStyle(color: Colors.grey[400]),
      );
    },
  );
}
