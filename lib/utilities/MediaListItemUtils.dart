import 'dart:io';

import 'package:files/pages/MediaPage/MediaPage.dart';

import 'package:files/utilities/Utils.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';

import '../sizeConfig.dart';

class MediaUtils {
  static double appbarSize = 12.5;
  static bool showBottomAppbar = true;

  static const backgroundColor = Color(0xFF2c2c3c);
  static String currentPath = '';
  static redirectToPage(BuildContext context, {page}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  static ontap(BuildContext context, FileSystemEntity data) {
    currentPath = data.path;
    if (data is File) {
      OpenFile.open(data.path);
    } else {
      redirectToPage(context, page: MediaPage());
    }
  }

  static Widget tab({page, @required context, child}) {
    return InkWell(
      onTap: () => MediaUtils.redirectToPage(context, page: page),
      child: child,
    );
  }

  static Widget description(FileSystemEntity data) {
    return FutureBuilder(
      future: FileUtils.checkFileType(data),
      builder: (context, snapshot) {
        var text = '';
        if (snapshot.hasData && snapshot.data.isNotEmpty) {
          text = snapshot.data;
        }
        return Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 1.4 * Responsive.textMultiplier,
            color: Colors.grey[700],
          ),
        );
      },
    );
  }
}
