import 'dart:io';

import 'package:files/decoration/my_decoration.dart';
import 'package:files/sizeConfig.dart';
import 'package:flutter/material.dart';

class VideoListItem extends StatefulWidget {
  final Color? selectedColor;
  final String? title;
  final Color? textColor;
  final Widget? description;
  final String? currentPath;
  final Function? ontap;
  final Function? onLongPress;
  final Widget? leading;
  final int? index;
  final FileSystemEntity? data;
  final Widget? trailing;
  final bool selected;

  const VideoListItem({
    Key? key,
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
    this.selected = false,
  });

  @override
  _VideoListItemState createState() => _VideoListItemState();
}

class _VideoListItemState extends State<VideoListItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.ontap as void Function()?,
      onLongPress: widget.onLongPress as void Function()?,
      child: AnimatedContainer(
        duration: MyDecoration.duration,
        color: widget.selected ? widget.selectedColor : null,
        padding: EdgeInsets.symmetric(
          horizontal: 4.width,
          vertical: 0.6.height,
        ),
        child: Row(
          children: <Widget>[
            widget.leading!,
            Expanded(
              child: _Item(
                description: widget.description,
                title: widget.title,
                titleColor: widget.textColor,
              ),
            ),
            if (widget.trailing != null) widget.trailing!,
          ],
        ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  final Widget? description;
  final String? title;
  final Color? titleColor;
  const _Item({this.description, this.title, this.titleColor});
  @override
  Widget build(BuildContext context) {
    final subtitle1 = Theme.of(context).textTheme.subtitle1!;
    return Container(
      padding: EdgeInsets.only(left: 4.0.width),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title!,
            style: subtitle1.copyWith(
              color: titleColor ?? subtitle1.color,
              fontSize: 1.7.text,
            ),
          ),
          SizedBox(height: 0.6.height),
          if (description != null) description!,
        ],
      ),
    );
  }
}
