import 'dart:io';

import 'package:files/decoration/my_decoration.dart';
import 'package:files/helpers/date_format_helper.dart';
import 'package:files/sizeConfig.dart';
import 'package:files/utilities/Utils.dart';
import 'package:flutter/material.dart';

import 'options_row.dart';

class OptionsBottomSheet extends StatelessWidget {
  const OptionsBottomSheet({
    Key key,
    @required this.name,
    @required this.file,
  }) : super(key: key);

  final String name;
  final File file;

  @override
  Widget build(BuildContext context) {
    final stat = file.statSync();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        MyDecoration.bottomSheetTopIndicator(
          heightFactor: 1.height,
          color: Colors.grey[700],
        ),
        SizedBox(height: 1.height),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.padding),
          child: OptionsRow(file: file),
        ),
        SizedBox(height: 1.height),
        Divider(),
        ListTile(
          leading: Icon(
            Icons.image,
            size: 10.image,
          ),
          title: Text(name),
          subtitle: Text(FileUtils.formatBytes(stat.size, 2)),
        ),
        SizedBox(height: 1.height),
        ListTile(
          title: Text(DateFormatter.formatDateInDMY(stat.modified)),
        ),
        SizedBox(height: 2.height),
      ],
    );
  }
}
