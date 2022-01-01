import 'package:files/data_models/VideoModel.dart';
import 'package:files/utilities/Utils.dart';
import 'package:files/widgets/MediaListItem.dart';
import 'package:flutter/material.dart';

import '../../sizeConfig.dart';
import 'video_leading.dart';

class VideosInFolders extends StatelessWidget {
  final List<VideoModel> videoFolders;
  final void Function(VideoModel videoModel) onTap;
  const VideosInFolders({Key key, this.videoFolders, @required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: videoFolders.length,
      physics: BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        final folder = videoFolders[index];
        return MediaListItem(
          currentPath: folder.folderName,
          data: folder.videos.first.file,
          index: index,
          description: Text(
            FileUtils.formatBytes(folder.totalSize, 2),
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 1.4 * Responsive.textMultiplier,
              color: Colors.grey[700],
            ),
          ),
          onLongPress: null,
          ontap: () => onTap(folder),
          title: folder.folderName,
          leading: LeadingVIdeo(video: folder.videos.first),
        );
      },
    );
  }
}
