import 'dart:io';
import 'package:files/pages/Photos/FullScreenImage.dart';
import 'package:files/provider/StoragePathProvider.dart';
import 'package:files/utilities/MediaListItemUtils.dart';
import 'package:files/widgets/FileNotFoundScreen.dart';
import 'package:files/widgets/MyAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class Photos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Widget widget = Consumer<StoragePathProvider>(
      builder: (BuildContext context, value, child) {
        return value.imagesPath.isNotEmpty
            ? GridView(photos: value.imagesPath)
            : FileNotFoundScreen();
      },
    );
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: MyAppBar(backgroundColor: Colors.grey[90]),
      body: Container(
        margin: const EdgeInsets.only(left: 12, right: 12, top: 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: widget,
        ),
      ),
    );
  }
}

class GridView extends StatelessWidget {
  final photos;
  const GridView({this.photos});
  @override
  Widget build(BuildContext context) {
    // final provider =

    return StaggeredGridView.countBuilder(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      physics: BouncingScrollPhysics(),
      itemCount: photos.length,
      itemBuilder: (BuildContext context, int index) {
        return Photo(file: photos[index], index: index);
      },
      staggeredTileBuilder: (int index) =>
          StaggeredTile.count(1, index.isEven ? 1.2 : 1.8),
    );
  }
}

class Photo extends StatelessWidget {
  final File file;
  final int index;
  const Photo({this.file, this.index});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StoragePathProvider>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      child: GestureDetector(
        onTap: () {
          MediaUtils.redirectToPage(
            context,
            page: FullScreenImage(
              index: index,
            ),
          );
          provider.updateIndex(index);
        },
        // onLongPress: () => _onLongPress(),
        child: Image.file(
          file,
          fit: BoxFit.cover,
          cacheWidth: 240,
        ),
      ),
    );
  }
}
