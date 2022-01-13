import 'dart:io';

import 'package:files/pages/Photos/photos_utils.dart';
import 'package:files/sizeConfig.dart';
import 'package:flutter/material.dart';

class OptionsRow extends StatelessWidget {
  final File file;
  const OptionsRow({Key key, this.file}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _Option(
          title: 'Set wallpaper',
          file: file,
          iconData: Icons.wallpaper,
          onPressed: () async {
            await PhotosUtils.setWallpaper(file);
            Navigator.pop(context);
          },
        ),
        SizedBox(width: 1.width),
        _Option(
          iconData: Icons.upload_file_outlined,
          title: 'Upload To Drive',
          file: file,
          onPressed: () {},
        ),
      ],
    );
  }
}

class _Option extends StatelessWidget {
  const _Option({
    Key key,
    @required this.file,
    @required this.onPressed,
    @required this.title,
    this.iconData,
  }) : super(key: key);

  final File file;
  final String title;
  final IconData iconData;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final themeData = ThemeData.dark();
    final bodyText = themeData.textTheme.bodyText2;
    return Column(
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(iconData),
        ),
        Text(
          title,
          style: bodyText,
        ),
      ],
    );
  }
}
