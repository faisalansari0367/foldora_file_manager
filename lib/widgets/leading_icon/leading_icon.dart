import 'dart:io';

import 'package:files/provider/LeadingIconProvider.dart';
import 'package:files/provider/OperationsProvider.dart';
import 'package:files/utilities/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as p;

import '../../sizeConfig.dart';

class LeadingIcon extends StatelessWidget {
  final BoxDecoration decoration;
  final Color iconBgColor; // background color of icon
  final Color iconColor; // this is the iconColor
  final FileSystemEntity data;
  final double imageRadius;

  const LeadingIcon({
    this.iconBgColor,
    this.iconColor,
    this.data,
    this.decoration,
    this.imageRadius,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OperationsProvider>(context, listen: false);
    final imageSize = Responsive.imageSize(11);
    final behaviour = data is Directory || isApk() ? Clip.none : Clip.antiAlias;
    final color = isApk() ? null : iconColor ?? MyColors.darkGrey;
    return InkWell(
      onTap: () => provider.onTapOfLeading(data),
      child: Container(
        // color: decoration == null ?  : null,
        height: imageSize,
        width: imageSize,
        clipBehavior: behaviour,
        decoration: decoration ??
            BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
        child: Consumer<IconProvider>(
          builder: (_, iconProvider, __) {
            return iconProvider.switchCaseForIcons(data);
          },
        ),
      ),
    );
  }

  bool isApk() {
    var result = false;
    if (data is! File) return result;
    if (p.extension(data.path) == '.apk') {
      result = true;
    }
    return result;
  }
}
