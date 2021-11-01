import 'dart:io';

import 'package:files/widgets/FileNotFoundScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'photo.dart';

class MyGridView extends StatefulWidget {
  final List<File> photos;
  const MyGridView({this.photos});

  @override
  _MyGridViewState createState() => _MyGridViewState();
}

class _MyGridViewState extends State<MyGridView> {
  final int _crossAxisCount = 2;

  @override
  Widget build(BuildContext context) {
    if (widget.photos.isEmpty) return FileNotFoundScreen();

    final grid = StaggeredGridView.countBuilder(
      padding: const EdgeInsets.all(8.0),
      crossAxisCount: _crossAxisCount,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      physics: const BouncingScrollPhysics(),
      itemCount: widget.photos.length,
      itemBuilder: (BuildContext context, int index) {
        return Photo(files: widget.photos, index: index);
      },
      staggeredTileBuilder: (int index) => StaggeredTile.count(1, index.isEven ? 1 : 1.25),
    );
    return GestureDetector(
      child: AnimationConfiguration.synchronized(
        duration: const Duration(milliseconds: 375),
        child: SlideAnimation(
          child: FadeInAnimation(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: grid,
            ),
          ),
        ),
      ),
    );
  }
}
