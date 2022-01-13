import 'package:files/pages/Videos/videos_page.dart';
import 'package:files/provider/videos_provider.dart';
import 'package:files/utilities/MediaListItemUtils.dart';
import 'package:files/utilities/Utils.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../MediaStack.dart';

class VideosTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<VideosProvider>(context, listen: true);
    final videosLength = provider.videosFiles.length;
    return MediaStack(
      onTap: () => MediaUtils.redirectToPage(context, page: VideosPage()),
      image: 'assets/doc.png',
      color: Color(0xff7e7dd6).withOpacity(0.2),
      media: 'Videos',
      items: '${videosLength ?? 0} items',
      privacy: 'Private Folder',
      shadow: Color(0xff7e7dd6).withOpacity(0.5),
      lock: Icon(
        Icons.lock_outline,
        color: Colors.indigo[500],
      ),
      size: FileUtils.formatBytes(provider.videosSize, 1),
      // size: '0.0 GB',
    );
  }
}
