import 'package:files/pages/Drive/drive_screen.dart';
import 'package:files/provider/drive_provider/drive_provider.dart';
import 'package:files/utilities/MediaListItemUtils.dart';
import 'package:files/utilities/Utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../MediaStack.dart';

class DriveTab extends StatefulWidget {
  @override
  State<DriveTab> createState() => _DriveTabState();
}

class _DriveTabState extends State<DriveTab> {
  static int items = 0;
  static String usedBytes = '0';
  @override
  void initState() {
    if (items != 0) return;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      // await Auth.initializeFirebase(context: context);
      final provider = Provider.of<DriveProvider>(context, listen: false);
      await provider.isReady;
      final list = await provider.getDriveFiles();
      usedBytes = provider.driveQuota?.usageInDrive ?? '0';
      items = list.length;
      if (!mounted) return;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final color = Color(0xff00ae45);
    return MediaStack(
      onTap: () => MediaUtils.redirectToPage(context, page: DriveScreen()),
      image: 'assets/drive.png',
      color: color.withOpacity(0.2),
      media: 'Drive',
      items: '$items Items',
      privacy: 'Private Folder',
      shadow: Colors.green.shade200,
      lock: Icon(
        Icons.lock_outline,
        color: color,
      ),
      size: FileUtils.formatBytes(int.parse(usedBytes), 2),
      // size: '0.0 GB',
    );
  }
}
