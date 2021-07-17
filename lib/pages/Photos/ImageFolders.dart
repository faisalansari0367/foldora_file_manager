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
    // return Scaffold(
    //   // appBar: MyAppBar(),
    //   body: ListView(
    //     children: [
    return ListView(
      children: [
        for (var item in images)
          FolderImage(
            image: File(item.files[0]),
            folderName: item.folderName,
            index: images.indexOf(item),
          )
      ],
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

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      height: 200,
      // width: 200,
      child: GestureDetector(
        onTap: () {
          final photos = images[index];
          final list = [for (var item in photos.files) File(item)];

          MediaUtils.redirectToPage(
            context,
            page: MyGridView(
              photos: list,
            ),
          );
        },
        child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,

          children: [
            Opacity(
              opacity: 0.4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  image,
                  cacheWidth: 720,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Center(
              child: Text(
                folderName,
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 20,
                ),
              ),
            ),
          ],
          //     ),
          //   ],
          // ),
        ),
      ),
    );
  }
}
