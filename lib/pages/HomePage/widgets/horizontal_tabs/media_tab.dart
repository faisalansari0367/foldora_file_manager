import 'dart:io';

import 'package:files/pages/MediaPage/MediaPage.dart';
import 'package:files/provider/MyProvider.dart';
import 'package:files/services/file_system/file_system.dart';
import 'package:files/utilities/MediaListItemUtils.dart';
import 'package:files/utilities/Utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../MediaStack.dart';

class MediaTab extends StatelessWidget {
  const MediaTab({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final storage = Provider.of<MyProvider>(context, listen: true);
    final pageView = PageView.builder(
      onPageChanged: (value) => storage.onPageChanged(value),
      itemCount: storage.data.length,
      itemBuilder: (context, index) {
        return MediaPage(
          storage: storage.data[index],
          spaceInfoIndex: index,
        );
      },
    );
    return FutureBuilder<List<FileSystemEntity>>(
      future: storage.files(),
      builder: (context, snapshot) {
        var usedStorage = 0;
        var size = ' ';
        int? itemsCount = 0;
        if (snapshot.hasData) {
          usedStorage = storage?.data[0]?.used ?? 0;
          size = FileUtils.formatBytes(usedStorage, 1);
          itemsCount = snapshot?.data?.length;
        }

        return MediaStack(
          onTap: () => MediaUtils.redirectToPage(context, page: pageView),
          image: 'assets/video.png',
          color: Colors.amber.withOpacity(0.2),
          media: 'Files',
          items: '${itemsCount ?? 0} items',
          privacy: 'Private Folder',
          shadow: Colors.amber[200],
          lock: Icon(
            Icons.lock_outline,
            color: Colors.amber[500],
          ),
          size: size ?? '0 GB',
        );
      },
    );
  }
}
