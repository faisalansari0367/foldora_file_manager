import 'dart:io';

import 'package:files/provider/MyProvider.dart';
import 'package:files/provider/OperationsProvider.dart';
import 'package:files/utilities/MediaListItemUtils.dart';
import 'package:files/utilities/MyColors.dart';
import 'package:files/widgets/MediaListItem.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';

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
      // key: UniqueKey(),
      future: provider.dirContents(path, isShowHidden: provider.showHidden),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data.isEmpty) {
          if (p.equals(path, provider.data[provider.currentPage].path)) {
            return Container();
          }
          return MediaUtils.fileNotFound();
        } else if (snapshot.hasData && snapshot.data.isNotEmpty) {
          final widget = DirectoryListItem(
            data: snapshot.data,
            scrollController: scrollController,
          );
          return widget;
          
        } else if (snapshot.hasError) {
          return MediaUtils.fileNotFound(message: snapshot.error.toString());
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
 

  @override
  Widget build(BuildContext context) {
    print('listBuilder');
    final provider = Provider.of<MyProvider>(context, listen: false);
    final operations = Provider.of<OperationsProvider>(context, listen: false);
    return Container(
      color: MyColors.white,
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        controller: widget.scrollController ?? ScrollController(),
        itemCount: widget.data.length,
        itemBuilder: (context, index) {
          final data = widget.data[index];
          final mediaListItem = MediaListItem(
            key: UniqueKey(),
            index: index,
            data: data,
            ontap: () {
              operations.selectedMedia.isNotEmpty
                  ? !operations.showCopy
                      ? provider.ontap(data)
                      : operations.onTapOfLeading(data)
                  : provider.ontap(data);
            },
            title: p.basename(data.path),
            currentPath: data.path,
            description: MediaUtils.description(data),
            leading: LeadingIcon(data: data),
            selectedColor: MyColors.darkGrey.withOpacity(0.2),
          );
          return mediaListItem;
        },
      ),
    );
  }
}
