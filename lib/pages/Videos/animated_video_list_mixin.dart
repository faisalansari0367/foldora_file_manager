import 'package:files/helpers/provider_helpers.dart';
import 'package:files/pages/Videos/video_list_item.dart';
import 'package:files/provider/videos_provider.dart';
import 'package:files/utilities/MediaListItemUtils.dart';
import 'package:files/utilities/MyColors.dart';
import 'package:flutter/material.dart';

import 'models/video_file.dart';
import 'video_leading.dart';

mixin AnimatedVideoListMixin {
  Widget itemRemover(BuildContext context, Animation<double> animation, file) {
    final _animation = animation.drive(CurveTween(curve: Curves.fastOutSlowIn));
    return FadeTransition(
      opacity: _animation,
      child: SizeTransition(
        sizeFactor: _animation,
        child: itemBuilder(context, file),
      ),
    );
  }

  Widget itemBuilder(BuildContext context, VideoFile file) {
    final provider = getProvider<VideosProvider>(context);
    final video = file;
    return VideoListItem(
      currentPath: video.file.path,
      description: MediaUtils.description(video.file),
      ontap: () => MediaUtils.ontap(context, video.file),
      title: video.displayName,
      selectedColor: MyColors.darkGrey.withOpacity(0.25),
      selected: provider.selectedFiles.contains(video),
      leading: LeadingVIdeo(
        video: video,
        onTap: () => provider.addOrRemoveVideos(video),
      ),
    );
  }
}