import 'package:files/helpers/provider_helpers.dart';
import 'package:files/pages/Videos/models/video_folder.dart';
import 'package:files/pages/Videos/videos_in_folders.dart';
import 'package:files/pages/Videos/videos_listview.dart';
import 'package:files/provider/videos_provider.dart';
import 'package:files/widgets/MyAppBar.dart';
import 'package:files/widgets/animated_widgets/my_slide_animation.dart';
import 'package:files/widgets/my_annotated_region.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import 'video_menu_options.dart';

class VideosPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = getProvider<VideosProvider>(context, listen: true);
    // final myProvider = getProvider<MyProvider>(context);

    // final videos = provider.videosFiles;
    return MyAnnotatedRegion(
      child: Scaffold(
        appBar: MyAppBar(actions: [VideoMenuOptions()]),
        body: Column(
          children: [
            // MediaStorageInfo(
            //   availableBytes: myProvider.spaceInfo.first.total - myProvider.spaceInfo.first.used,
            //   totalBytes: myProvider.spaceInfo.first.total,
            //   usedBytes: provider.videosSize,
            //   storageName: 'Videos',
            // ),
            // MediaFiles(
            //   filesName: 'Video Files',
            // ),
            Expanded(
              child: WillPopScope(
                onWillPop: () => provider.onGoBack(),
                child: Selector<VideosProvider, Tuple2<VideoFolder, bool>>(
                  selector: (p0, p1) => Tuple2(p1.selectedVideoFolder, p1.showInFolders),
                  builder: (context, data, child) {
                    var widget;
                    if (data.item2 && data.item1 == null) {
                      widget = VideosListview(
                        videos: provider.videosFiles,
                      );
                    } else if (data.item1 == null) {
                      widget = VideosInFolders(
                        videoFolders: provider.videosFolder,
                        onSelect: (VideoFolder folder) => provider.addOrRemoveVideos(folder),
                        onTap: (VideoFolder folder) => provider.onTap(folder),
                      );
                    } else {
                      widget = VideosListview(
                        videos: data.item1.files,
                      );
                    }
                    return MySlideAnimation(
                      key: UniqueKey(),
                      child: widget,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
