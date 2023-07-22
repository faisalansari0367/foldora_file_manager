import 'package:files/provider/MyProvider.dart';
import 'package:files/provider/drive_provider/drive_deleter_provider.dart';
import 'package:files/provider/drive_provider/drive_downloader_provider.dart';
import 'package:files/provider/local_auth_provider.dart';
import 'package:files/provider/videos_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'provider/LeadingIconProvider.dart';
import 'provider/OperationsProvider.dart';
import 'provider/storage_path_provider.dart';
import 'provider/drive_provider/drive_provider.dart';
import 'provider/scroll_provider.dart';

class AddProviders extends StatelessWidget {
  final Widget child;
  const AddProviders({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MyProvider>(
          create: (context) => MyProvider(),
        ),
        ChangeNotifierProvider<IconProvider>(
          create: (context) => IconProvider(),
        ),
        ChangeNotifierProvider<OperationsProvider>(
          create: (context) => OperationsProvider(),
        ),
        ChangeNotifierProvider<ScrollProvider>(
          create: (context) => ScrollProvider(),
        ),
        ChangeNotifierProvider<DriveProvider>(
          create: (context) => DriveProvider(),
        ),
        ChangeNotifierProvider<DriveDownloader>(
          create: (context) => DriveDownloader(),
        ),
        ChangeNotifierProvider<DriveDeleter>(
          create: (context) => DriveDeleter(),
        ),
        ChangeNotifierProvider<VideosProvider>(
          create: (context) => VideosProvider(),
        ),
        ChangeNotifierProxyProvider<VideosProvider, StoragePathProvider?>(
          create: (context) => StoragePathProvider(),
          update: (context, value, previous) => previous?..setVideosSize(value.videosSize),
        ),
        ChangeNotifierProvider<LocalAuth>(
          create: (context) => LocalAuth(),
        ),
      ],
      child: child,
    );
  }
}
