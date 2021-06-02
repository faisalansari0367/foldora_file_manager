import 'dart:typed_data';

import 'package:files/utilities/MyColors.dart';
import 'package:flutter/material.dart';

import '../sizeConfig.dart';

class Widgets {
  static const IconData fileIcon = Icons.insert_drive_file;
  static final heightWidth = Responsive.imageSize(11);

  static Widget forImage(
    dynamic path, {
    BoxDecoration decoration,
    int cacheHeight,
    int cacheWidth,
    double radius,
  }) {
    // final heightWidth = Responsive.imageSize(11);
    final imageSize = Responsive.imageSize(5);
    return Container(
      decoration: decoration,
      height: heightWidth,
      width: heightWidth,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius ?? 25),
        child: path is Uint8List
            ? Image.memory(
                path,
                height: imageSize,
                width: imageSize,
              )
            : Image.file(
                path,
                fit: BoxFit.cover,
                cacheHeight: cacheHeight,
                cacheWidth: cacheWidth,
                height: imageSize,
                width: imageSize,
              ),
      ),
    );
  }

  static Widget folderIcons(
    IconData folderIcon, {
    Color iconColor,
    BoxDecoration decoration,
    Color bgColor,
    Uint8List bytes,
  }) {
    final position = Responsive.imageSize(5.5);
    // final heightWidth = 11 * Responsive.imageSizeMultiplier;

    final defaultDecoration = BoxDecoration(
      color: bgColor ?? MyColors.darkGrey,
      borderRadius: BorderRadius.circular(25),
    );
    final Widget dirIcon = Container(
      decoration: decoration ?? defaultDecoration,
      child: Container(
        height: heightWidth,
        width: heightWidth,
        child: Icon(
          folderIcon,
          size: Responsive.imageSize(5),
          color: iconColor ?? Colors.white,
        ),
      ),
    );

    if (bytes == null) return dirIcon;
    final Widget dirPositionedIcon = Positioned(
      top: position,
      left: position,
      child: Image.memory(
        bytes,
        height: position,
        width: position,
      ),
    );

    final Widget stack = Stack(
      children: [dirIcon, dirPositionedIcon],
    );

    return stack;
  }
}
