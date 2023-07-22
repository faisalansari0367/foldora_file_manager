import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path/path.dart' as p;

class MyImage {
  static Widget asset(
    String path, {
    double? width,
    double? height,
    BoxFit? fit,
    AlignmentGeometry? alignment,
    PictureProvider? pictureProvider,
    WidgetBuilder? placeholderBuilder,
    bool? matchTextDirection,
    bool? allowDrawingOutsideViewBox,
    String? semanticsLabel,
    Color? color,
    bool? excludeFromSemantics,
    Clip? clipBehavior,
    ColorFilter? colorFilter,
    int? cacheHeight,
    int? cacheWidth,
  }) {
    final ext = p.extension(path);

    if (ext == '.svg') {
      return SvgPicture.asset(
        path,
        width: width,
        alignment: alignment ?? Alignment.center,
        allowDrawingOutsideViewBox: allowDrawingOutsideViewBox!,
        height: height,
        color: color,
        fit: fit ?? BoxFit.contain,
        placeholderBuilder: placeholderBuilder,
      );
    } else {
      return Image.asset(
        path,
        width: width,
        alignment: alignment ?? Alignment.center,
        height: height,
        color: color,
        fit: fit ?? BoxFit.contain,
        cacheHeight: cacheHeight,
        cacheWidth: cacheWidth,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset('assets/images/2_404 Error.png');
        },
      );
    }
  }

  static Widget file(
    File file, {
    double? width,
    double? height,
    BoxFit? fit,
    AlignmentGeometry? alignment,
    PictureProvider? pictureProvider,
    WidgetBuilder? placeholderBuilder,
    bool? matchTextDirection,
    bool? allowDrawingOutsideViewBox,
    String? semanticsLabel,
    Color? color,
    bool? excludeFromSemantics,
    Clip? clipBehavior,
    ColorFilter? colorFilter,
    int? cacheHeight,
    int? cacheWidth,
  }) {
    final ext = p.extension(file.path);

    if (ext == '.svg') {
      return SvgPicture.file(
        file,
        width: width,
        alignment: alignment!,
        allowDrawingOutsideViewBox: allowDrawingOutsideViewBox!,
        height: height,
        color: color,
        fit: fit!,
        placeholderBuilder: placeholderBuilder,
      );
    } else {
      return Image.file(
        file,
        width: width,
        alignment: alignment!,
        height: height,
        color: color,
        fit: fit,
        cacheHeight: cacheHeight,
        cacheWidth: cacheWidth,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset('assets/images/2_404 Error.png');
        },
      );
    }
  }
}
