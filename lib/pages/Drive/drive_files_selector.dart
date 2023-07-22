import 'dart:io';

import 'package:files/decoration/my_decoration.dart';
import 'package:files/provider/drive_provider/drive_provider.dart';
import 'package:files/utilities/MediaListItemUtils.dart';
import 'package:files/utilities/MyColors.dart';
import 'package:files/widgets/leading_icon/leading_icon.dart';
import 'package:files/widgets/MediaListItem.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';

class DriveFilesSelector extends StatelessWidget {
  final ScrollController? controller;
  final List<FileSystemEntity> data;
  final List<FileSystemEntity>? selectedFiles;
  final Widget? trailing;
  final void Function(FileSystemEntity) onTap;
  final void Function(FileSystemEntity)? onPressed;
  final bool Function(FileSystemEntity)? isSelected;

  const DriveFilesSelector({
    Key? key,
    this.controller,
    required this.data,
    this.trailing,
    required this.onTap,
    this.onPressed,
    this.isSelected,
    this.selectedFiles,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller,
      physics: MyDecoration.physics,
      itemCount: data.length,
      itemBuilder: (context, index) {
        final file = data[index];
        return MediaListItem(
          index: index,
          data: file,
          trailing: TrailingWidget(file: file, onPressed: onPressed),
          title: p.basename(file.path),
          currentPath: file.path,
          description:
              MediaUtils.description(file, textColor: Colors.grey[600]),
          leading: LeadingIcon(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              color: Colors.white10,
            ),
            data: file,
            iconColor: Colors.white38,
          ),
          ontap: () => onTap(file),
          selectedColor: MyColors.darkGrey,
          textColor: Colors.grey[400],
        );
      },
    );
  }
}

class TrailingWidget extends StatefulWidget {
  const TrailingWidget({
    Key? key,
    // @required this.selectedFiles,
    required this.file,
    required this.onPressed,
    // this.selectedFiles,
  }) : super(key: key);

  // final List<FileSystemEntity> selectedFiles;
  final FileSystemEntity file;
  final void Function(FileSystemEntity p1)? onPressed;

  @override
  State<TrailingWidget> createState() => _TrailingWidgetState();
}

class _TrailingWidgetState extends State<TrailingWidget> {
  bool isExist(List<FileSystemEntity> list, FileSystemEntity file) {
    var match = false;
    for (var item in list) {
      if (item.path == file.path) {
        match = true;
        break;
      }
    }
    return match;
  }

  @override
  Widget build(BuildContext context) {
    final driveProvider = Provider.of<DriveProvider>(context, listen: true);

    return IconButton(
      icon: Icon(
        isExist(driveProvider.filesToUpload, widget.file)
            ? Icons.check_circle_outline_rounded
            : Icons.circle_outlined,
        color: MyColors.appbarActionsColor,
      ),
      onPressed: () {
        widget.onPressed!(widget.file);
      },
    );
  }
}
