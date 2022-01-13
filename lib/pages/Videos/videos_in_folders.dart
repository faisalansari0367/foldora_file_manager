import 'package:files/pages/Videos/models/video_folder.dart';
import 'package:files/utilities/Utils.dart';
import 'package:files/widgets/MediaListItem.dart';
import 'package:flutter/material.dart';

import '../../sizeConfig.dart';
import 'video_leading.dart';

class VideosInFolders extends StatelessWidget {
  final List<VideoFolder> videoFolders;
  final void Function(VideoFolder folder) onTap;
  final void Function(VideoFolder folder) onSelect;

  const VideosInFolders({Key key, this.videoFolders, @required this.onTap, this.onSelect}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: videoFolders.length,
      physics: BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        final folder = videoFolders[index];
        return MediaListItem(
          
          selectedColor: Colors.blueGrey[500],
          currentPath: folder.folderName,
          data: folder.files.first.file,
          index: index,
          description: Text(
            FileUtils.formatBytes(folder.size, 2),
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 1.4 * Responsive.textMultiplier,
              color: Colors.grey[700],
            ),
          ),
          onLongPress: null,
          ontap: () => onTap(folder),
          title: folder.folderName,
          leading: GestureDetector(
            onTap: () => onSelect(folder),
            child: LeadingVIdeo(video: folder.files.first),
          ),
        );
      },
    );
  }
}
