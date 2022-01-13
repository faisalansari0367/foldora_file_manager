import 'package:files/pages/Videos/models/video_file.dart';
import 'package:files/utilities/MediaListItemUtils.dart';
import 'package:files/widgets/MediaListItem.dart';
import 'package:flutter/material.dart';

import 'video_leading.dart';

class VideosListview extends StatelessWidget {
  final List<VideoFile> videos;
  const VideosListview({Key key, this.videos = const []}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: videos.length,
      physics: BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        final video = videos[index];
        return MediaListItem(
          currentPath: video.file.path,
          data: video.file,
          index: index,
          description: MediaUtils.description(video.file),
          onLongPress: null,
          ontap: () => MediaUtils.ontap(context, video.file),
          title: video.displayName,
          leading: LeadingVIdeo(video: video),
        );
      },
    );
  }
}
