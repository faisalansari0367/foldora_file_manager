// import 'dart:html';
import 'dart:io';

import 'package:files/provider/StoragePathProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FullScreenImage extends StatelessWidget {
  final int index;
  FullScreenImage({this.index});
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StoragePathProvider>(context, listen: false);

    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Center(
          child: PageView.builder(
            allowImplicitScrolling: true,
            physics: BouncingScrollPhysics(),
            controller: PageController(initialPage: index),
            itemCount: provider.imagesPath.length,
            itemBuilder: (context, index) {
              return Image.file(provider.imagesPath[index]);
            },
          ),
        ),
      ),
    );
  }
}

Widget pageViewBuilder(List<File> photos) {
  return PageView.builder(
    itemCount: photos.length,
    itemBuilder: (context, index) {
      return Scaffold(body: Image.file(photos[index]));
    },
  );
}
