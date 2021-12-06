import 'package:flutter/material.dart';

import '../../sizeConfig.dart';

// bool getSelectedItem(List<FileSystemEntity> files, String path) {
//   var isSelected = false;
//   for (var item in files) {
//     if (path == item.path) {
//       isSelected = true;
//       break;
//     } else {
//       isSelected = false;
//     }
//   }
//   return isSelected;
// }

class DriveListItem extends StatefulWidget {
  final Color selectedColor;
  final Widget title;
  final Color textColor;
  final Widget description;
  final String currentPath;
  final Function ontap;
  final Function onLongPress;
  final Widget leading;
  final int index;
  // final FileSystemEntity data;
  final IconButton trailing;

  const DriveListItem({
    Key key,
    this.index,
    this.title,
    this.description,
    this.currentPath,
    this.ontap,
    this.onLongPress,
    this.leading,
    // this.data,
    this.selectedColor,
    this.textColor,
    this.trailing,
  });

  @override
  _DriveListItemState createState() => _DriveListItemState();
}

class _DriveListItemState extends State<DriveListItem> {
  // static const duration = Duration(milliseconds: 300);
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
      child: padding,
    );
  }
}

class _Item extends StatelessWidget {
  final Widget description;
  final Widget title;
  final Color titleColor;
  const _Item({this.description, this.title, this.titleColor});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(left: Responsive.width(4.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Text(
            //   title,
            //   style: subtitle1.copyWith(
            //     color: titleColor ?? subtitle1.color,
            //   ),
            // ),
            title,
            SizedBox(height: Responsive.height(0.5)),
            if (description != null) description,
          ],
        ),
      ),
    );
  }
}

