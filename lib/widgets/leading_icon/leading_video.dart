import 'dart:io';

import 'package:files/utilities/video_utils.dart';
import 'package:files/widgets/leading_icon/leading_image.dart';
import 'package:flutter/material.dart';

class VideoIcon extends StatefulWidget {
  final File video;
  const VideoIcon({Key key, @required this.video}) : super(key: key);

  @override
  State<VideoIcon> createState() => _VideoIconState();
}

class _VideoIconState extends State<VideoIcon> {
  static const initalData = Icon(Icons.video_collection_rounded);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: builder,
      initialData: initalData,
      future: futureWidget(),
    );
  }

  Future<File> futureWidget() async {
    final data = VideoUtil.isVideoThumbnailExist(widget.video.path);
    if (data['isFileExist']) {
      return data['thumb'];
    }
    final thumbnail = await VideoUtil.createThumbnail(widget.video.path);
    return thumbnail;
  }

  Widget builder(BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.connectionState == ConnectionState.done) {
      return LeadingImage(file: snapshot.data);
    }
    return initalData;
  }
}
