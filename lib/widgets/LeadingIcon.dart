import 'dart:io';

import 'package:files/provider/LeadingIconProvider.dart';
import 'package:files/provider/OperationsProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    return Center(
      child: InkWell(
        onTap: () => provider.onTapOfLeading(data),
        child: Consumer<IconProvider>(
          builder: (_, iconProvider, __) {
            return iconProvider.switchCaseForIcons(
              data,
              iconBgColor: iconBgColor,
              iconColor: iconColor,
              decoration: decoration,
            );
          },
        ),
      ),
    );
  }
}
