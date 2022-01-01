import 'dart:io';

import 'package:files/decoration/my_decoration.dart';
import 'package:files/provider/storage_path_provider.dart';
import 'package:files/sizeConfig.dart';
import 'package:files/utilities/MediaListItemUtils.dart';
import 'package:files/utilities/MyColors.dart';
import 'package:files/utilities/Utils.dart';
import 'package:files/widgets/MyAppBar.dart';
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
      physics: MyDecoration.physics,
      padding: const EdgeInsets.all(8),
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
        return FolderImage(
          image: image,
          folderName: item.folderName,
          index: index,
          folderSize: FileUtils.formatBytes(item.folderSize, 2),
        );
      },
    );
  }
}

class FolderImage extends StatelessWidget {
  final File image;
  final String folderName;
  final String folderSize;
  final int index;
  const FolderImage({@required this.image, @required this.folderName, @required this.index, this.folderSize});

  @override
  Widget build(BuildContext context) {
    final images = Provider.of<StoragePathProvider>(context, listen: false).imagesPath;
    final theme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () {
        final photos = images[index];
        final list = [for (var item in photos.files) File(item)];
        MediaUtils.redirectToPage(
          context,
          page: Scaffold(
            backgroundColor: Colors.black,
            appBar: MyAppBar(
              backgroundColor: Colors.black,
              title: Text(photos.folderName),
            ),
            body: MyGridView(
              photos: list,
            ),
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
                cacheWidth: 480,
                width: 50.width,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    folderName ?? '',
                    style: theme.subtitle2.copyWith(color: MyColors.whitish),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '${images[index].files.length} Items',
                    style: theme.caption.copyWith(color: MyColors.whitish),
                  ),
                ],
              ),
              Text(
                '$folderSize',
                style: theme.caption.copyWith(color: MyColors.whitish),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
