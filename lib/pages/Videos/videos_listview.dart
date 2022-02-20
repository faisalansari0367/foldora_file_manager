import 'package:files/decoration/my_decoration.dart';
import 'package:files/helpers/provider_helpers.dart';
import 'package:files/pages/Videos/animated_video_list_mixin.dart';
import 'package:files/pages/Videos/models/video_file.dart';
import 'package:files/provider/videos_provider.dart';
import 'package:flutter/material.dart';

class VideosListview extends StatefulWidget {
  final List<VideoFile> videos;
  const VideosListview({Key key, this.videos = const []}) : super(key: key);

  @override
  State<VideosListview> createState() => _VideosListviewState();
}

class _VideosListviewState extends State<VideosListview> with AnimatedVideoListMixin {
  @override
  Widget build(BuildContext context) {
    final provider = getProvider<VideosProvider>(context);
    final videos = widget.videos;
    return AnimatedList(
      initialItemCount: videos.length,
      physics: MyDecoration.physics,
      key: provider.listKey,
      itemBuilder: (context, index, animation) => itemBuilder(context, videos[index]),
    );
  }
}
