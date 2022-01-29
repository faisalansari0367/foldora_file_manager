import 'package:files/decoration/my_decoration.dart';
import 'package:files/helpers/provider_helpers.dart';
import 'package:files/pages/Videos/models/video_file.dart';
import 'package:files/pages/Videos/video_list_item.dart';
import 'package:files/provider/videos_provider.dart';
import 'package:files/utilities/MediaListItemUtils.dart';
import 'package:files/utilities/MyColors.dart';
import 'package:flutter/material.dart';

import 'video_leading.dart';

class VideosListview extends StatefulWidget {
  final List<VideoFile> videos;
  const VideosListview({Key key, this.videos = const []}) : super(key: key);

  @override
  State<VideosListview> createState() => _VideosListviewState();
}

class _VideosListviewState extends State<VideosListview> {
  // final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  @override
  Widget build(BuildContext context) {
    final provider = getProvider<VideosProvider>(context);

    return AnimatedList(
      initialItemCount: widget.videos.length,
      physics: MyDecoration.physics,
      key: provider.listKey,
      itemBuilder: animatedItemBuilder,
    );

    // return ListView.builder(
    //   itemCount: widget.videos.length,
    //   physics: MyDecoration.physics,
    //   itemBuilder: itemBuilder,
    // );
  }

  Widget animatedItemBuilder(context, index, animation) => itemBuilder(context, index);

  Widget itemBuilder(context, index) {
    final provider = getProvider<VideosProvider>(context);

    final video = widget.videos[index];
    return VideoListItem(
      currentPath: video.file.path,
      data: video.file,
      index: index,
      description: MediaUtils.description(video.file),
      ontap: () => MediaUtils.ontap(context, video.file),
      title: video.displayName,
      selectedColor: MyColors.darkGrey.withOpacity(0.25),
      selected: provider.selectedFiles.contains(video),
      leading: LeadingVIdeo(
        video: video,
        onTap: () => onTap(context, video),
      ),
    );
  }

  void onTap(context, VideoFile video) {
    final provider = getProvider<VideosProvider>(context);
    provider.addOrRemoveVideos(video);
  }
}
