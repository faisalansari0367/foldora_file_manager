import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../sizeConfig.dart';

class Widgets {
  static const IconData fileIcon = Icons.insert_drive_file;

  static forImage(path, {cacheHeight, cacheWidth}) {
    final heightWidth = 11 * Responsive.imageSizeMultiplier;
    return Container(
      height: heightWidth,
      width: heightWidth,
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.circular(25),
        color: Colors.white,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: path is Uint8List
            ? Image.memory(
                path,
                height: 5 * Responsive.imageSizeMultiplier,
                width: 5 * Responsive.imageSizeMultiplier,
              )
            : Image.file(
                path,
                fit: BoxFit.cover,
                cacheHeight: cacheHeight,
                cacheWidth: cacheWidth,
                height: 5 * Responsive.imageSizeMultiplier,
                width: 5 * Responsive.imageSizeMultiplier,
              ),
      ),
    );
  }

  static folderIcons(
    IconData folderIcon, {
    Color iconColor,
    Color bgColor,
    Uint8List bytes,
  }) {
    final position = 5.5 * Responsive.imageSizeMultiplier;
    final heightWidth = 11 * Responsive.imageSizeMultiplier;
    final Widget dirIcon = Container(
      decoration: BoxDecoration(
        color: bgColor ?? Color(0xFF2c2c3c),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Container(
        height: heightWidth,
        width: heightWidth,
        child: Icon(
          folderIcon,
          size: 5 * Responsive.imageSizeMultiplier,
          color: iconColor ?? Colors.white,
        ),
      ),
    );

    final Widget dirPositionedIcon = bytes == null
        ? Container(width: 0.0, height: 0.0)
        : Positioned(
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
