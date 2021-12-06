import 'dart:io';

import 'package:files/provider/OperationsProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../sizeConfig.dart';

bool getSelectedItem(List<FileSystemEntity> files, String path) {
  var isSelected = false;
  for (var item in files) {
    if (path == item.path) {
      isSelected = true;
      break;
    } else {
      isSelected = false;
    }
  }
  return isSelected;
}

class MediaListItem extends StatefulWidget {
  final Color selectedColor;
  final String title;
  final Color textColor;
  final Widget description;
  final String currentPath;
  final Function ontap;
  final Function onLongPress;
  final Widget leading;
  final int index;
  final FileSystemEntity data;
  final Widget trailing;

  const MediaListItem({
    Key key,
    this.index,
    this.title,
    this.description,
    this.currentPath,
    this.ontap,
    this.onLongPress,
    this.leading,
    this.data,
    this.selectedColor,
    this.textColor,
    this.trailing,
  });

  @override
  _MediaListItemState createState() => _MediaListItemState();
}

class _MediaListItemState extends State<MediaListItem> {
  static const duration = Duration(milliseconds: 300);
  @override
  Widget build(BuildContext context) {
    final Widget padding = Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.width(4),
        vertical: Responsive.height(0.6),
      ),
      child: Row(
        children: <Widget>[
          widget.leading,
          _Item(
            description: widget.description,
            title: widget.title,
            titleColor: widget.textColor,
          ),
          if (widget.trailing != null) widget.trailing,
        ],
      ),
    );

    return InkWell(
      onTap: widget.ontap,
      onLongPress: widget.onLongPress,
      child: Consumer<OperationsProvider>(
        child: padding,
        builder: (context, provider, child) {
          final isSelected =
              getSelectedItem(provider.selectedMedia, widget.data.path);
          final color = isSelected ? widget.selectedColor : Colors.transparent;
          return AnimatedContainer(
            duration: duration,
            color: color,
            child: child,
          );
        },
      ),
    );
  }
}

class _Item extends StatelessWidget {
  final Widget description;
  final String title;
  final Color titleColor;
  const _Item({this.description, this.title, this.titleColor});
  @override
  Widget build(BuildContext context) {
    final subtitle1 = Theme.of(context).textTheme.subtitle1;
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(left: Responsive.width(4.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: subtitle1.copyWith(
                color: titleColor ?? subtitle1.color,
              ),
            ),
            SizedBox(height: Responsive.height(0.5)),
            if (description != null) description,
          ],
        ),
      ),
    );
  }
}
