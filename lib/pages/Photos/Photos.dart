import 'dart:io';
import 'package:files/pages/Photos/FullScreenImage.dart';
import 'package:files/provider/StoragePathProvider.dart';
import 'package:files/utilities/MediaListItemUtils.dart';
import 'package:files/utilities/MyColors.dart';
import 'package:files/widgets/FileNotFoundScreen.dart';
import 'package:files/widgets/MyAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
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
      appBar: MyAppBar(backgroundColor: MyColors.darkGrey),
      body: Container(
        margin: const EdgeInsets.only(left: 12, right: 12, top: 12),
        child: widget,
      ),
    );
  }
}

class GridView extends StatefulWidget {
  final photos;
  const GridView({this.photos});

  @override
  _GridViewState createState() => _GridViewState();
}

class _GridViewState extends State<GridView> {
  int _crossAxisCount = 2;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleUpdate: (ScaleUpdateDetails newScale) {
        final scale = newScale.scale.toInt();
        if (scale > 0) _crossAxisCount = newScale.scale.toInt() * 2;
        setState(() {});
      },
      child: StaggeredGridView.countBuilder(
        crossAxisCount: _crossAxisCount,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        physics: BouncingScrollPhysics(),
        itemCount: widget.photos.length,
        itemBuilder: (BuildContext context, int index) {
          final child = Photo(file: widget.photos[index], index: index);
          // return child;
          return AnimationConfiguration.staggeredGrid(
            columnCount: _crossAxisCount,
            position: index,
            // delay: Duration(milliseconds: 10),
            child: SlideAnimation(
              child: FadeInAnimation(
                child: child,
              ),
            ),
          );
        },
        staggeredTileBuilder: (int index) =>
            StaggeredTile.count(1, index.isEven ? 1.2 : 1.8),
      ),
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
