import 'dart:io';

import 'package:files/provider/StoragePathProvider.dart';
import 'package:files/utilities/MediaListItemUtils.dart';
import 'package:files/utilities/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'gridview.dart';

class ImageFolders extends StatefulWidget {
  const ImageFolders();

  @override
  _ImageFoldersState createState() => _ImageFoldersState();
}

class _ImageFoldersState extends State<ImageFolders> {
  @override
  Widget build(BuildContext context) {
    final images = Provider.of<StoragePathProvider>(context, listen: false).imagesPath;
    return GridView.builder(
      itemCount: images.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        childAspectRatio: 0.75,
      ),
      itemBuilder: (context, index) {
        final item = images[index];
        final image = File(item.files.first);
        return Container(
          margin: EdgeInsets.all(4),
          child: FolderImage(
            image: image,
            folderName: item.folderName,
            index: index,
          ),
        );
      },
    );
  }
}

class FolderImage extends StatelessWidget {
  final File image;
  final String folderName;
  final int index;
  const FolderImage({@required this.image, @required this.folderName, @required this.index});

  @override
  Widget build(BuildContext context) {
    final images = Provider.of<StoragePathProvider>(context, listen: false).imagesPath;
    final theme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () {
        final photos = images[index];
        final list = [for (var item in photos.files) File(item)];
        print(photos);
        MediaUtils.redirectToPage(
          context,
          page: MyGridView(
            photos: list,
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                image,
                // cacheWidth: 720,
                width: 400,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(folderName, style: theme.subtitle2.copyWith(color: MyColors.whitish)),
          SizedBox(height: 5),
          Text(
            '${images[index].files.length} Items',
            style: theme.caption.copyWith(color: MyColors.whitish),
          ),
        ],
      ),
    );
  }
}