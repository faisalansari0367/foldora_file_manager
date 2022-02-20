import 'dart:typed_data';

import 'package:files/sizeConfig.dart';
import 'package:flutter/material.dart';

final _position = 5.image;

class FolderLeading extends StatelessWidget {
  final IconData iconData;
  final Color color;
  final Uint8List folderIcon;
  const FolderLeading({Key key, this.iconData = Icons.folder_open_rounded, this.color, this.folderIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final container = Container(
      color: color,
      child: Icon(
        iconData,
        color: Colors.grey.shade300,
      ),
    );

    if (folderIcon == null) return container;
    return Stack(
      alignment: Alignment.center,
      children: [
        container,
        Positioned(
          bottom: 0,
          right: 0,
          child: Image.memory(
            folderIcon,
            height: _position,
            width: _position,
          ),
        ),
      ],
    );
  }
}
