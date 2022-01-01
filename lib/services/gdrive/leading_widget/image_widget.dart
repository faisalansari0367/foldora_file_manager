import 'dart:io';

import 'package:files/widgets/my_image.dart';
import 'package:flutter/material.dart';

class ImageFileIcon extends StatelessWidget {
  final String path;
  const ImageFileIcon({Key key, @required this.path}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return MyImage.file(
      File(path),
    );
  }
}
