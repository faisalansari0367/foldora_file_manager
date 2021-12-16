import 'package:files/provider/storage_path_provider.dart';
import 'package:files/utilities/MediaListItemUtils.dart';
import 'package:files/utilities/video_utils.dart';
import 'package:files/widgets/MediaListItem.dart';
import 'package:files/widgets/MyAppBar.dart';
import 'package:files/widgets/my_annotated_region.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VideosPage extends StatelessWidget {

  
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StoragePathProvider>(context);
    final videos = provider.videosFiles;
    return MyAnnotatedRegion(
      child: Scaffold(
        appBar: MyAppBar(),
        body: ListView.builder(
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
              leading: FutureBuilder(
                future: VideoUtil.createThumbnail(video.file.path),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();
                  return SizedBox(
                    height: 70,
                    width: 100,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        snapshot.data,
                        fit: BoxFit.cover,
                        // height: 200,
                        // width: 100,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
        // bottomNavigationBar: Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: MyElevatedButton(
        //     text: ('move all videos to a different folder'),
        //     onPressed: () async {
        //       final dir =
        //           await Directory('/storage/emulated/0/AllVideos').create();

        //       final provider =
        //           Provider.of<OperationsProvider>(context, listen: false);
        //       for (var item in videos) {
        //         provider.onTapOfLeading(item.file);
        //       }

        //       for (var item in provider.selectedMedia) {
        //         await provider.move(dir.path);
        //         print('item is moving $item');
        //       }
        //     },
        //   ),
        // ),
      ),
    );
  }
}
