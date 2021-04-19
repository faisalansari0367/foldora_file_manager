import 'dart:io';

import 'package:files/provider/MyProvider.dart';
// import 'package:files/provider/OperationsProvider.dart';

import 'package:files/utilities/MediaListItemUtils.dart';
// import 'package:files/utilities/Utils.dart';
import 'package:files/widgets/MediaListItem.dart';
import 'package:flutter/material.dart';
// import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as p;

import 'FileNotFoundScreen.dart';
import 'LeadingIcon.dart';

class DirectoryLister extends StatelessWidget {
  final String path;
  const DirectoryLister({this.path});

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
            return FileNotFoundScreen(message: message);
          }
        } else if (snapshot.hasData && snapshot.data.isNotEmpty) {
          return Container(
            child: DirectoryListItem(
              data: snapshot.data,
            ),
            color: Colors.transparent,
          );
        } else if (snapshot.hasError) {
          return FileNotFoundScreen(
            message: snapshot.error.toString(),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class DirectoryListItem extends StatefulWidget {
  final String path;
  final data;

  DirectoryListItem({Key key, this.data, this.path}) : super(key: key);

  @override
  _DirectoryListItemState createState() => _DirectoryListItemState();
}

class _DirectoryListItemState extends State<DirectoryListItem> {
  ScrollController _scrollController;
  // GlobalKey key = GlobalKey();
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();

    print('directoryListBuilder disposed');
  }

  @override
  Widget build(BuildContext context) {
    print("listBuilder");
    final provider = Provider.of<MyProvider>(context, listen: false);
    return Container(
      color: Colors.white,
      child: ListView.builder(
        key: UniqueKey(),
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        controller: _scrollController,
        itemCount: widget.data.length,
        itemBuilder: (context, index) {
          final FileSystemEntity data = widget.data[index];
          return MediaListItem(
            index: index,
            data: data,
            // ontap: () => MediaUtils.ontap(context, data),
            ontap: () => provider.ontap(data),
            title: p.basename(data.path),
            currentPath: data.path,
            description: MediaUtils.description(data),
            leading: LeadingIcon(
              data: data,
              iconAccent: Color(0xFF2c2c3c),
              iconColor: Colors.white,
              iconName: Icons.folder_open,
            ),
          );
        },
      ),
    );
  }
}
