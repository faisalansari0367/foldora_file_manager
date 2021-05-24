import 'dart:io';

import 'package:files/provider/LeadingIconProvider.dart';
import 'package:files/provider/OperationsProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LeadingIcon extends StatelessWidget {
  final Color iconBgColor; // background color of icon
  final Color iconColor; // this is the iconColor
  final FileSystemEntity data;

  const LeadingIcon({
    this.iconBgColor,
    this.iconColor,
    this.data,
  });

  Widget build(BuildContext context) {
    final provider = Provider.of<Operations>(context, listen: false);
    return Center(
      child: InkWell(
        onTap: () => provider.onTapOfLeading(data),
        child: Consumer<IconProvider>(
          builder: (_, iconProvider, __) {
            return iconProvider.switchCaseForIcons(data,
                iconBgColor: iconBgColor, iconColor: iconColor);
          },
        ),
      ),
    );
  }
}
