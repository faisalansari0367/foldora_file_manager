import 'dart:io';

import 'package:files/provider/MyProvider.dart';
import 'package:files/provider/OperationsProvider.dart';
import 'package:files/utilities/MediaListItemUtils.dart';
import 'package:files/widgets/MediaListItem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as p;
import 'LeadingIcon.dart';

class DirectoryLister extends StatelessWidget {
  final String path;
  final ScrollController scrollController;
  const DirectoryLister({this.path, this.scrollController});

  static final String message =
      'This folder is empty. The file you are looking for is not here. Please search in different folder.';

  Widget build(BuildContext context) {
    final provider = Provider.of<MyProvider>(context, listen: true);

    return FutureBuilder(
      future: provider.dirContents(path, isShowHidden: provider.showHidden),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data.isEmpty) {
          if (p.equals(path, provider.data[provider.currentPage].path)) {
            return Container();
          }
          return MediaUtils.fileNotFound(message);
        } else if (snapshot.hasData && snapshot.data.isNotEmpty) {
          return Container(
            color: Colors.transparent,
            child: DirectoryListItem(
              data: snapshot.data,
              scrollController: scrollController,
            ),
          );
        } else if (snapshot.hasError) {
          return MediaUtils.fileNotFound(snapshot.error.toString());
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class DirectoryListItem extends StatefulWidget {
  final String path;
  final Color selected;
  final List<FileSystemEntity> data;
  final ScrollController scrollController;

  const DirectoryListItem({
    Key key,
    this.data,
    this.path,
    this.selected,
    this.scrollController,
  });

  @override
  _DirectoryListItemState createState() => _DirectoryListItemState();
}

class _DirectoryListItemState extends State<DirectoryListItem> with SingleTickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(vsync: this, duration: Duration(seconds: 1));
    controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("listBuilder");
    final provider = Provider.of<MyProvider>(context, listen: false);
    final operations = Provider.of<Operations>(context, listen: false);
    return Container(
      color: Colors.white,
      // height: Responsive.height(100),
      child: ListView.builder(
        key: UniqueKey(),
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        controller: widget.scrollController ?? ScrollController(),
        itemCount: widget.data.length,
        itemBuilder: (context, index) {
          final data = widget.data[index];
          final mediaListItem = MediaListItem(
            index: index,
            data: data,
            ontap: () => operations.selectedMedia.isNotEmpty
                ? operations.onTapOfLeading(data)
                : provider.ontap(data),
            title: p.basename(data.path),
            currentPath: data.path,
            description: MediaUtils.description(data),
            leading: LeadingIcon(data: data),
            selectedColor: Colors.grey[200],
          );
          // return AnimationConfiguration.synchronized(
          //   duration: Duration(milliseconds: 500),
          //   child: SlideAnimation(
          //     // delay: Duration(milliseconds: 2000),
          //     verticalOffset: 20.0,
          //     // curve: Curves.easeIn,
          //     child: FadeInAnimation(
          //       // duration: Duration(milliseconds: index * 1000),
          //       child: mediaListItem,
          //     ),
          //   ),
          // );

          // return AnimatedBuilder(
          //   animation: controller,
          //   child: mediaListItem,
          //   builder: (BuildContext context, Widget child) {
          //     final begin = index == 0 ? 0.0 : (index - 1) / widget.data.length;
          //     final end = index / widget.data.length;
          //     return FadeTransition(
          //       opacity: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
          //         parent: controller,
          //         curve: Interval(begin, end),
          //       )),
          //       child: child,
          //     );
          //   },
          // );

          return mediaListItem;
        },
      ),
    );
  }
}
