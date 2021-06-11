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
          if (p.equals(path, provider.getDirPath)) {
            return Container();
          } else {
            return MediaUtils.fileNotFound(message);
          }
        } else if (snapshot.hasData && snapshot.data.isNotEmpty) {
          return Container(
            color: Colors.transparent,
            child: DirectoryListItem(
                data: snapshot.data, scrollController: scrollController),
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

  DirectoryListItem(
      {Key key, this.data, this.path, this.selected, this.scrollController})
      : super(key: key);

  @override
  _DirectoryListItemState createState() => _DirectoryListItemState();
}

class _DirectoryListItemState extends State<DirectoryListItem> {
  // GlobalKey key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    print("listBuilder");
    final provider = Provider.of<MyProvider>(context, listen: false);
    final operations = Provider.of<Operations>(context, listen: false);
    return Container(
      color: Colors.white,
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
          return AnimationConfiguration.synchronized(
            duration: Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 20.0,
              child: FadeInAnimation(
                child: mediaListItem,
              ),
            ),
          );
        },
      ),
    );
  }
}
