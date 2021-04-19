import 'dart:io';

import 'package:files/provider/OperationsProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../sizeConfig.dart';

class MediaListItem extends StatefulWidget {
  final String title;
  final Widget description;
  final String currentPath;
  final Function ontap;
  final Function onLongPress;
  final Widget leading;
  final int index;
  final FileSystemEntity data;

  const MediaListItem({
    this.index,
    this.title,
    this.description,
    this.currentPath,
    this.ontap,
    this.onLongPress,
    this.leading,
    this.data,
  });

  @override
  _MediaListItemState createState() => _MediaListItemState();
}

class _MediaListItemState extends State<MediaListItem> {
  Widget build(BuildContext context) {
    final Widget padding = Padding(
      padding: EdgeInsets.only(
        right: 4 * Responsive.widthMultiplier,
        bottom: 0.6 * Responsive.heightMultiplier,
        top: 0.6 * Responsive.heightMultiplier,
        left: 4 * Responsive.widthMultiplier,
      ),
      child: Row(
        children: <Widget>[
          widget.leading,
          _Item(
            description: widget.description,
            title: widget.title,
          ),
        ],
      ),
    );

    return InkWell(
      onTap: widget.ontap,
      onLongPress: widget.onLongPress,
      child: Consumer<Operations>(
        builder: (context, provider, child) {
          final selectedMedia = provider.selectedMedia;
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(0),
              color: selectedMedia.contains(widget.data)
                  ? Colors.grey[300]
                  : Colors.transparent,
            ),
            child: child,
          );
        },
        child: padding,
      ),
    );
  }
}

class _Item extends StatelessWidget {
  final Widget description;
  final title;
  const _Item({
    this.description,
    this.title,
  });
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(left: 4.0 * Responsive.widthMultiplier),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                fontSize: 1.9 * Responsive.textMultiplier,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(
              height: 0.5 * Responsive.heightMultiplier,
            ),
            description,
          ],
        ),
      ),
    );
  }
}
