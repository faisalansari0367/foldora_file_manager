import 'package:files/provider/storage_path_provider.dart';
import 'package:files/utilities/MyColors.dart';
import 'package:files/widgets/FileNotFoundScreen.dart';
import 'package:files/widgets/MyAppBar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ImageFolders.dart';
import 'gridview.dart';

class Photos extends StatefulWidget {
  // final tabs = [GridView()];
  @override
  State<Photos> createState() => _PhotosState();
}

class _PhotosState extends State<Photos> with SingleTickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final tabbar = TabBar(
      indicatorColor: MyColors.teal,
      controller: tabController,
      labelColor: MyColors.teal,
      unselectedLabelColor: MyColors.white,
      tabs: [
        Tab(
          text: ('All Photos'),
        ),
        Tab(
          text: ('Folders'),
        )
      ],
    );
    final Widget widget = Consumer<StoragePathProvider>(
      builder: (BuildContext context, value, child) {
        final grid = value.allPhotos.isNotEmpty ? MyGridView(photos: value.allPhotos) : FileNotFoundScreen();
        return TabBarView(
          controller: tabController,
          physics: BouncingScrollPhysics(),
          children: [grid, ImageFolders()],
        );
      },
    );
    return AnnotatedRegion(
      value: AppbarUtils.systemUiOverylay(systemNavigationBarColor: Colors.black),
      child: Scaffold(
        // bottomNavigationBar: BottomSlideAnimation(),
        backgroundColor: Colors.black54,
        appBar: MyAppBar(
          bottomNavBar: true,
          backgroundColor: Colors.black54,
          bottom: tabbar,
        ),
        body: widget,
      ),
    );
  }
}
