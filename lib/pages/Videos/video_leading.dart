import 'package:files/pages/Videos/models/video_file.dart';
import 'package:files/sizeConfig.dart';
import 'package:files/utilities/video_utils.dart';
import 'package:flutter/material.dart';

class LeadingVIdeo extends StatelessWidget {
  const LeadingVIdeo({
    Key key,
    @required this.video,
    this.onTap,
  }) : super(key: key);

  final VideoFile video;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        clipBehavior: Clip.antiAlias,
        height: 7.5.height,
        width: 25.width,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
        child: video.thumbnail != null
            ? Image.memory(video.thumbnail, fit: BoxFit.cover)
            : FutureBuilder(
                future: VideoUtil.createThumbnail(video.file.path),
                builder: (context, snapshot) {
                  return !snapshot.hasData
                      ? Center(child: CircularProgressIndicator())
                      : Image.file(snapshot.data, fit: BoxFit.cover);
                },
              ),
      ),
    );
  }
}
