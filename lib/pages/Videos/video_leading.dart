import 'package:files/pages/Videos/models/video_file.dart';
import 'package:files/sizeConfig.dart';
import 'package:files/utilities/video_utils.dart';
import 'package:flutter/material.dart';

class LeadingVIdeo extends StatelessWidget {
  const LeadingVIdeo({
    Key key,
    @required this.video,
  }) : super(key: key);

  final VideoFile video;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: VideoUtil.createThumbnail(video.file.path),
      builder: (context, snapshot) {
        return SizedBox(
          height: 8.height,
          width: 25.width,
          child: !snapshot.hasData
              ? Center(child: CircularProgressIndicator())
              : ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    snapshot.data,
                    fit: BoxFit.cover,
                  ),
                ),
        );
      },
    );
  }
}
