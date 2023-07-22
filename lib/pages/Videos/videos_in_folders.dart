import 'package:files/decoration/my_decoration.dart';
import 'package:files/helpers/provider_helpers.dart';
import 'package:files/pages/Videos/models/video_folder.dart';
import 'package:files/pages/Videos/video_list_item.dart';
import 'package:files/provider/videos_provider.dart';
import 'package:files/utilities/MyColors.dart';
import 'package:files/utilities/Utils.dart';
import 'package:flutter/material.dart';

import '../../sizeConfig.dart';
import 'video_leading.dart';

class VideosInFolders extends StatelessWidget {
  final List<VideoFolder>? videoFolders;
  final void Function(VideoFolder folder) onTap;
  final void Function(VideoFolder folder)? onSelect;
  final bool selected;

  const VideosInFolders({Key? key, this.videoFolders, required this.onTap, this.onSelect, this.selected = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = getProvider<VideosProvider>(context);

    return ListView.builder(
      itemCount: videoFolders!.length,
      physics: MyDecoration.physics,
      itemBuilder: (context, index) {
        final folder = videoFolders![index];
        return VideoListItem(
          selectedColor: MyColors.darkGrey.withOpacity(0.2),
          currentPath: folder.folderName,
          data: folder.files.first.file,
          selected: provider.selectedFiles.contains(folder),
          description: Text(
            FileUtils.formatBytes(folder.size, 2),
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 1.4 * Responsive.textMultiplier,
              color: Colors.grey[700],
            ),
          ),
          ontap: () => onTap(folder),
          title: folder.folderName,
          leading: GestureDetector(
            onTap: () => onSelect!(folder),
            child: LeadingVIdeo(video: folder.files.first),
          ),
        );
      },
    );
  }
}
