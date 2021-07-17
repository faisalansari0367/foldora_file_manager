import 'dart:io';

import 'package:files/provider/StoragePathProvider.dart';
import 'package:files/utilities/MediaListItemUtils.dart';
import 'package:files/utilities/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'FullScreenImage.dart';

class Photo extends StatelessWidget {
  final File file;
  final int index;
  const Photo({this.file, this.index});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StoragePathProvider>(context, listen: true);
    return GestureDetector(
      onLongPress: () {
        provider.onLongPress(index);
      },
      onTap: () {
        if (provider.selectedPhotos.isNotEmpty) return provider.addImage(index);
        MediaUtils.redirectToPage(context, page: FullScreenImage(index: index, file: file));
        provider.updateIndex(index);
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            child: Image.file(
              file,
              fit: BoxFit.cover,
              cacheWidth: 240,
            ),
          ),
          if (provider.selectedPhotos.isNotEmpty) ...[
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black12, Colors.transparent],
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Checkbox(
                fillColor: MaterialStateProperty.all(Colors.white70),
                checkColor: MyColors.darkGrey,
                value: provider.selectedPhotos.contains(index),
                onChanged: (_) {
                  provider.addImage(index);
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
