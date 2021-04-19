import 'package:files/pages/HomePage/widgets/MediaStack.dart';
import 'package:files/pages/MediaPage/MediaPage.dart';
import 'package:files/pages/Photos/Photos.dart';
import 'package:files/provider/StoragePathProvider.dart';
import 'package:files/provider/MyProvider.dart';
import 'package:files/utilities/MediaListItemUtils.dart';
import 'package:files/utilities/Utils.dart';
import 'package:files/widgets/LeadingIcon.dart';
import 'package:files/widgets/MediaListItem.dart';
import 'package:files/widgets/MyAppBar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../sizeConfig.dart';

// enum StorageType { INTERNAL, REMOVABLE, OTG }

class HorizontalTabs extends StatelessWidget {
  // Widget _sdCardWidget() {
  //   return Selector<MyProvider, List>(
  //     selector: (_, provider) => provider.spaceInfo,
  //     builder: (context, value, child) {
  //       print(value.length);
  //       if (value.length > 1) {
  //         return Helper.tab(
  //           context: context,
  //           page: MediaPage(
  //             path: value[1].path,
  //             // storage: value[1],
  //           ),
  //           child: _SdCard(
  //             path: value[1].path,
  //           ),
  //         );
  //       } else {
  //         return SizedBox(height: 0, width: 0);
  //       }
  //     },
  //   );
  // }

  final Widget sizedBox = SizedBox(width: 5 * Responsive.widthMultiplier);

  @override
  Widget build(BuildContext context) {
    print('horizontal tabs');
    final MyProvider provider = Provider.of<MyProvider>(context, listen: true);
    final list = provider?.data;
    final PageView pageView = PageView.builder(
      onPageChanged: (value) => provider.onPageChanged(value),
      physics: BouncingScrollPhysics(),
      key: UniqueKey(),
      itemCount: list.length,
      itemBuilder: (context, index) {
        print(list[index]);
        return MediaPage(
          storage: list[index],
          spaceInfoIndex: index,
        );
      },
    );

    List<Widget> children = <Widget>[
      sizedBox,
      MediaUtils.tab(child: _PhotosTab(), page: Photos(), context: context),
      sizedBox,
      MediaUtils.tab(
        child: _MediaTab(),
        context: context,
        page: pageView,
      ),
      sizedBox,
      MediaUtils.tab(child: _VideosTab(), page: VideosPage(), context: context),
      sizedBox,
      // _sdCardWidget(),
      // sizedBox,
    ];

    return Container(
      height: 40 * Responsive.heightMultiplier,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        // controller: ScrollController(),
        children: children,
      ),
    );
  }
}

class _PhotosTab extends StatelessWidget {
  const _PhotosTab({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<StoragePathProvider>(
      builder: (BuildContext context, photos, child) {
        var itemsCount = photos.imagesPath.length;
        var size = photos.photosSize;
        return MediaStack(
          image: "assets/image.png",
          color: Colors.green.withOpacity(0.15),
          media: "Photos",
          items: "$itemsCount Items",
          privacy: "Private Folder",
          shadow: Colors.green[200],
          lock: Icon(
            Icons.lock_outline,
            color: Colors.green[500],
          ),
          size: FileUtils.formatBytes(size, 1),
        );
      },
    );
  }
}

class _MediaTab extends StatelessWidget {
  _MediaTab({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final storage = Provider.of<MyProvider>(context, listen: false);
    return FutureBuilder(
      future: storage.files(),
      builder: (context, snapshot) {
        var usedStorage = 0;
        var size = ' ';
        var itemsCount = 0;
        if (snapshot.hasData) {
          usedStorage = storage?.data[0]?.used ?? 0;
          size = FileUtils.formatBytes(usedStorage, 1);
          itemsCount = snapshot?.data?.length;
        }
        return MediaStack(
          image: "assets/video.png",
          color: Colors.amber.withOpacity(0.2),
          media: "Files",
          items: "${itemsCount ?? 0} items",
          privacy: "Private Folder",
          shadow: Colors.amber[200],
          lock: Icon(
            Icons.lock_outline,
            color: Colors.amber[500],
          ),
          size: size ?? '0 GB',
        );
      },
    );
  }
}

class _SdCard extends StatelessWidget {
  final String path;
  _SdCard({Key key, this.path}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MyProvider provider = Provider.of<MyProvider>(context);
    return FutureBuilder(
      future: provider.dirContents(path),
      builder: (context, snapshot) {
        final value = snapshot?.data;
        final itemsCount = value?.length;
        return MediaStack(
          image: "assets/doc.png",
          color: Colors.indigo[100].withOpacity(0.1),
          media: "Sd card",
          items: "${itemsCount ?? 0} items",
          privacy: "Private Folder",
          shadow: Colors.indigo[200],
          lock: Icon(
            Icons.lock_outline,
            color: Colors.indigo[500],
          ),
          size: FileUtils.formatBytes((provider.spaceInfo[1].used), 1),
          // size: '0.0 GB',
        );
      },
    );
  }
}

class _VideosTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StoragePathProvider>(context, listen: true);
    final videosLength = provider.videosFiles.length;
    return MediaStack(
      image: "assets/doc.png",
      color: Color(0xff7e7dd6).withOpacity(0.2),
      media: "Videos",
      items: "${videosLength ?? 0} items",
      privacy: "Private Folder",
      shadow: Color(0xff7e7dd6).withOpacity(0.5),
      lock: Icon(
        Icons.lock_outline,
        color: Colors.indigo[500],
      ),
      size: FileUtils.formatBytes((provider.videosSize), 1),
      // size: '0.0 GB',
    );
  }
}

class VideosPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StoragePathProvider>(context);
    var videos = provider.videosFiles;
    return Scaffold(
      appBar: MyAppBar(),
      body: ListView.builder(
        itemCount: videos.length,
        itemBuilder: (context, index) {
          var video = videos[index];
          return MediaListItem(
            currentPath: video.file.path,
            data: video.file,
            index: index,
            description: MediaUtils.description(video.file),
            onLongPress: null,
            ontap: () => MediaUtils.ontap(context, video.file),
            title: video.displayName,
            leading: LeadingIcon(
              data: video.file,
              iconAccent: Color(0xFF2c2c3c),
              iconColor: Colors.white,
              iconName: Icons.folder_open,
            ),
          );
        },
      ),
    );
  }
}
