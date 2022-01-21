import 'package:files/pages/Drive/leading_drive.dart';
import 'package:files/provider/drive_provider/drive_deleter_provider.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/drive/v3.dart';
import 'package:provider/provider.dart';

import 'description.dart';
import 'drive_list_item.dart';

class DriveSliverListview extends StatelessWidget {
  final ScrollController controller;
  final List<File> data;
  final Function(File) onTap, onTapIcon;

  const DriveSliverListview({
    Key key,
    this.controller,
    this.data,
    @required this.onTap,
    @required this.onTapIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print('building drive sliver list items');
    // return CustomScrollView(
    //   slivers: <Widget>[
    //     SliverList(
    //       delegate: SliverChildBuilderDelegate(itemBuilder),
    //     ),
    //   ],
    // );
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        itemBuilder,
        childCount: data.length,

        // controller: controller ?? ScrollController(),
        // shrinkWrap: false,
        // itemCount: data.length,
      ),
    );
  }

  Widget itemBuilder(context, index) {
    print('driver sliver list view builder building');
    final file = data[index];
    return DriveListItem(
      title: Text(
        file.name,
        style: Theme.of(context).textTheme.subtitle1,
      ),
      ontap: () => onTap(file),
      description: Description(
        bytes: file.size,
        createdTime: file.createdTime,
      ),
      leading: Selector<DriveDeleter, List<String>>(
        selector: (p0, p1) => p1.fileIds,
        builder: (context, value, child) {
          return LeadingDrive(
            onTap: () => onTapIcon(file),
            isSelected: value.contains(file.id),
            id: file.id,
            extension: file.fullFileExtension,
            iconLink: file.iconLink.replaceAll('/16/', '/64/'),
          );
        },
      ),
    );
  }
}
