import 'dart:typed_data';

import 'package:files/utilities/MyColors.dart';
import 'package:files/widgets/leading_icon/leading_folder.dart';
import 'package:flutter/material.dart';

class LeadingApk extends StatelessWidget {
  // final Uint8List bytes;
  final Future<Uint8List> future;
  const LeadingApk({Key key, @required this.future}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final icon = ClipOval(child: FolderLeading(iconData: Icons.android_rounded, color: MyColors.darkGrey));
    // if (bytes == null) return FolderLeading(iconData: Icons.android_rounded);
    return FutureBuilder(
      future: future,
      initialData: icon,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            return Image.memory(
              snapshot.data,
              alignment: Alignment.center,
              fit: BoxFit.contain,
            );
            break;
          default:
            return icon;
        }
      },
    );
  }
}
