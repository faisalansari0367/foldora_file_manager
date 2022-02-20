import 'dart:io';

import 'package:files/sizeConfig.dart';
import 'package:flutter/material.dart';

class LeadingImage extends StatelessWidget {
  final File file;
  const LeadingImage({Key key, @required this.file}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.file(
      file,
      cacheWidth: 50.image.toInt(),
      fit: BoxFit.cover,
    );
  }
}
