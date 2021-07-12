import 'dart:io';
import 'package:files/pages/Photos/FullScreenImage.dart';
import 'package:files/provider/StoragePathProvider.dart';
import 'package:files/utilities/MediaListItemUtils.dart';
import 'package:files/utilities/MyColors.dart';
import 'package:files/widgets/BottomAnimation.dart';
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
      bottomNavigationBar: BottomSlideAnimation(),
      backgroundColor: Colors.black54,
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
        physics: const BouncingScrollPhysics(),
        itemCount: widget.photos.length,
        itemBuilder: (BuildContext context, int index) {
          final child = Photo(file: widget.photos[index], index: index);
          return child;
          // return AnimationConfiguration.synchronized(
          //   // columnCount: _crossAxisCount,
          //   // position: index,
          //   duration: Duration(seconds: 1),
          //   child: SlideAnimation(
          //     child: FadeInAnimation(
          //       child: child,
          //     ),
          //   ),
          // );
        },
        staggeredTileBuilder: (int index) => StaggeredTile.count(1, index.isEven ? 1.2 : 1.8),
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
    final provider = Provider.of<StoragePathProvider>(context, listen: true);
    // provider.selectedPhotos.isNotEmpty
    //     ? BottomSlideAnimation.controller.forward()
    //     : BottomSlideAnimation.controller.reverse();
    // return ClipRRect(
    // borderRadius: BorderRadius.all(Radius.circular(12)),
    return GestureDetector(
        onLongPress: () {
          provider.onLongPress(index);
          // provider.selectedPhotos.is
          // BottomSlideAnimation.controller
        },
        onTap: () {
          MediaUtils.redirectToPage(context, page: FullScreenImage(index: index));
          provider.updateIndex(index);
        },
        // onLongPress: () => _onLongPress(),
        // child: Stack(
        // children: [
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              child: Image.file(
                file,
                fit: BoxFit.cover,
                cacheWidth: 240,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black54, Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.center,
                ),
              ),

              // child: ClipRRect(
              //   borderRadius: BorderRadius.all(Radius.circular(12)),
              //   child: Image.file(
              //     file,
              //     fit: BoxFit.cover,
              //     cacheWidth: 240,
              //   ),
              // ),
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: Checkbox(
                fillColor: MaterialStateProperty.all(Colors.white54),
                value: false,
                onChanged: (value) {},
              ),
            ),
          ],
          // decoration: BoxDecoration(),
          // child: ClipRRect(
          //   borderRadius: BorderRadius.all(Radius.circular(12)),
          //   child: Image.file(
          //     file,
          //     fit: BoxFit.cover,
          //     cacheWidth: 240,
          //   ),
          // ),
        )
        // if (provider.selectedPhotos.contains(index))
        //   Positioned(
        //     bottom: 10,
        //     right: 25, // alignment: Alignment.bottomRight,
        //     child: Container(
        //       decoration: BoxDecoration(
        //         shape: BoxShape.circle,
        //         boxShadow: [
        //           BoxShadow(
        //             color: Colors.black,
        //             blurRadius: 40,
        //           )
        //         ],
        //       ),
        //       child: Icon(
        //         Icons.check_circle_outline,
        //         color: MyColors.teal,
        //       ),
        //     ),
        //   ),
        // ],
        // ),
        // ),
        );
  }
}
