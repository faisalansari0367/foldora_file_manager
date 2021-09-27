import 'dart:io';
import 'package:files/provider/StoragePathProvider.dart';
import 'package:files/widgets/FileNotFoundScreen.dart';
import 'package:files/widgets/MyAppBar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ImageFolders.dart';
import 'gridview.dart';

class Photos extends StatelessWidget {
  // final tabs = [GridView()];
  @override
  Widget build(BuildContext context) {
    final Widget widget = Consumer<StoragePathProvider>(
      builder: (BuildContext context, value, child) {
        final photos = [
          for (var item in value.imagesPath)
            for (var i in item.files) File(i),
        ];
        final grid =
            value.imagesPath.isNotEmpty ? MyGridView(photos: photos) : FileNotFoundScreen();
        return PageView(children: [grid, ImageFolders()]);
      },
    );
    return Scaffold(
      // bottomNavigationBar: BottomSlideAnimation(),
      backgroundColor: Colors.black54,
      appBar: MyAppBar(
        backgroundColor: Colors.black54,
      ),
      body: widget,
    );
  }
}
