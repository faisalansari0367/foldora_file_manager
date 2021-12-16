import 'package:files/pages/Photos/Photos.dart';
import 'package:files/provider/storage_path_provider.dart';
import 'package:files/utilities/MediaListItemUtils.dart';
import 'package:files/utilities/Utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../MediaStack.dart';

class PhotosTab extends StatelessWidget {
  const PhotosTab({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<StoragePathProvider>(
      builder: (BuildContext context, photos, child) {
        var length = 0;
        for (var item in photos.imagesPath) {
          length += item.files.length;
        }
        final itemsCount = length;
        print(itemsCount);
        final size = photos.photosSize;
        return MediaStack(
          onTap: () => MediaUtils.redirectToPage(context, page: Photos()),
          image: 'assets/image.png',
          color: Colors.green.withOpacity(0.15),
          media: 'Photos',
          items: '$itemsCount Items',
          privacy: 'Private Folder',
          shadow: Colors.green[200],
          lock: Icon(
            Icons.lock_outline,
            color: Colors.green[500],
          ),
          size: FileUtils.formatBytes(size, 1),
        );
      },
    );
  }
}
