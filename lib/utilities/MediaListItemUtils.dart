import 'dart:io';

import 'package:files/pages/MediaPage/MediaPage.dart';

import 'package:files/utilities/Utils.dart';
import 'package:files/widgets/FileNotFoundScreen.dart';
import 'package:files/widgets/animated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
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
    return AnimatedButton(
      onTap: () => MediaUtils.redirectToPage(context, page: page),
      child: child,
    );
  }

  static Widget fileNotFound(String message) {
    return AnimationConfiguration.synchronized(
      child: SlideAnimation(
        child: FadeInAnimation(
          curve: Curves.easeInOutExpo,
          child: FileNotFoundScreen(message: message.toUpperCase()),
        ),
      ),
    );
  }

  static Widget description(FileSystemEntity data, {Color textColor}) {
    // var text = '';
    // if (data is File) text = FileUtils.formatBytes(data.statSync().size, 2);
    // if (data is Directory) {
    //   text = 'Directory';
    // }
    // return Text(
    //   text,
    //   style: TextStyle(
    //     fontWeight: FontWeight.w400,
    //     fontSize: 1.4 * Responsive.textMultiplier,
    //     color: textColor ?? Colors.grey[700],
    //   ),
    // );

    return FutureBuilder(
      future: FileUtils.worker.doWork(FileUtils.checkFileType, data),
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
            color: textColor ?? Colors.grey[700],
          ),
        );
      },
    );
  }
}
