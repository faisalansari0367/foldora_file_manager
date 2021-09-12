import 'dart:io';

import 'package:files/provider/MyProvider.dart';
import 'package:files/provider/OperationsProvider.dart';
import 'package:files/utilities/MediaListItemUtils.dart';
import 'package:files/widgets/MediaListItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as p;
import 'LeadingIcon.dart';

const String message =
    'This folder is empty. The file you are looking for is not here. Please search in different folder.';

class DirectoryLister extends StatelessWidget {
  final String path;
  final ScrollController scrollController;
  const DirectoryLister({this.path, this.scrollController});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MyProvider>(context, listen: true);

    return FutureBuilder(
      key: UniqueKey(),
      future: provider.dirContents(path, isShowHidden: provider.showHidden),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data.isEmpty) {
          if (p.equals(path, provider.data[provider.currentPage].path)) {
            return Container();
          }
          return MediaUtils.fileNotFound(message);
        } else if (snapshot.hasData && snapshot.data.isNotEmpty) {
          final widget = DirectoryListItem(
            data: snapshot.data,
            scrollController: scrollController,
          );
          return widget;
          // return AnimationConfiguration.synchronized(
          //   duration: const Duration(milliseconds: 500),
          //   child: SlideAnimation(
          //     verticalOffset: 50.0,
          //     child: FadeInAnimation(
          //       child: widget,
          //     ),
          //   ),
          // );
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

class _DirectoryListItemState extends State<DirectoryListItem> {
  // AnimationController _controller;
  // Animation<double> animation;
  // @override
  // void initState() {
  //   _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 1000));
  //   animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
  //   _controller.forward();
  //   super.initState();
  // }

  // @override
  // void dispose() {
  //   _controller.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    print('listBuilder');
    final provider = Provider.of<MyProvider>(context, listen: false);
    final operations = Provider.of<OperationsProvider>(context, listen: false);
    return ListView.builder(
      physics: BouncingScrollPhysics(),
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
        //   // duration: Duration(milliseconds: 100),
        //   child: SlideAnimation(
        //     // delay: Duration(milliseconds: 2000),
        //     verticalOffset: 10.0,
        //     curve: Curves.easeOutCubic,
        //     child: FadeInAnimation(
        //       // duration: Duration(milliseconds: index * 1000),
        //       child: mediaListItem,
        //     ),
        //   ),
        // );

        // return AnimatedBuilder(
        //   animation: _controller,
        //   child: mediaListItem,
        //   builder: (BuildContext context, Widget child) {
        //     final begin = index == 0 ? 0.0 : (index - 1) / widget.data.length;
        //     final end = index / widget.data.length;
        //     print('end: $end, begin: $begin');
        //     return FadeTransition(
        //       opacity: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        //         parent: _controller,
        //         curve: Curves.easeInCubic,
        //       )),
        //       child: SlideTransition(
        //         position: Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset(0.0, 0.0))
        //             .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInCubic)),
        //         child: child,
        //       ),
        //     );
        //   },
        // );

        return mediaListItem;
      },
    );
  }
}
