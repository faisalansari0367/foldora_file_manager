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
        final grid =
            value.allPhotos.isNotEmpty ? MyGridView(photos: value.allPhotos) : FileNotFoundScreen();
        return PageView(children: [grid, ImageFolders()]);
      },
    );
    return AnnotatedRegion(
      value: AppbarUtils.systemUiOverylay(
        systemNavigationBarColor: Colors.black,
      ),
      child: Scaffold(
        // bottomNavigationBar: BottomSlideAnimation(),
        backgroundColor: Colors.black54,
        appBar: MyAppBar(
          backgroundColor: Colors.black54,
        ),
        body: widget,
      ),
    );
  }
}
