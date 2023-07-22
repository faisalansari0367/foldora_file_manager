import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

// import 'package:device_apps/app_utils.dart';
// import 'package:device_apps/device_apps.dart';
import 'package:files/models/apps.dart';
import 'package:files/services/database/local_apps_service.dart';
import 'package:files/services/database/system_apps_service.dart';
import 'package:files/widgets/leading_icon/leading_apk.dart';
import 'package:files/widgets/leading_icon/leading_folder.dart';
import 'package:files/widgets/leading_icon/leading_image.dart';
import 'package:files/widgets/leading_icon/leading_video.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class IconProvider extends ChangeNotifier {
  // SharedPreferences _prefs;
  // SharedPreferences get prefs => _prefs;
  Database? db;
  List<Apps>? systemApps = [];
  List<Apps>? localApps = [];
  final localAppsService = LocalAppsService();

  IconProvider() {
    _init();
  }

  Future<void> _init() async {
    // await _initPrefs();
    await _getINstalledApplications();
  }

  Future<void> _getINstalledApplications() async {
    final systemAppsService = SystemAppsService();
    final stopwatch = Stopwatch()..start();
    final list = await Future.wait([localAppsService.getApps(), systemAppsService.getApps()]);
    localApps = list.first;
    systemApps = list.last;
    log('apps took ${stopwatch.elapsedMilliseconds} ms to get data');
    stopwatch.stop();
    print('system apps count ${systemApps!.length}');
    print('local apps count ${localApps!.length}');
    notifyListeners();
  }

  // Future<Uint8List> _toShowApkIcon(path) async {
  //   // return [];
  //   // final appsData = await DeviceApps.getAppByApkFile([path.path]);
  //   // if (appsData.isEmpty) return null;
  //   // final List<App> apps = await FileUtils.worker.doWork(App.fromList, appsData);
  //   // final app = apps.first;
  //   // await localAppsService.insert(Apps.toMap(app));
  //   // return app.appIcon;
  // }

  Uint8List? getFolderIcon(String path) {
    Uint8List? icon;
    final name = p.basename(path);
    for (final item in systemApps!) {
      if (item.name == name || item.packageName == name) {
        icon = item.icon;
        break;
      }
    }
    return icon;
  }

  Widget switchCaseForIcons(FileSystemEntity? data) {
    if (data is Directory) {
      return FolderLeading(folderIcon: getFolderIcon(data.path));
    }
    switch (p.extension(data!.path).toLowerCase()) {
      case '.mp3':
      case '.m4a':
      case '.ac3':
      case '.aac':
      case '.3ga':
      case '.wav':
      case '.wma':
        return FolderLeading(iconData: Icons.library_music);

        break;
      case '.mp4':
      case '.mkv':
      case '.3gp':
      case '.wmv':
      case '.avi':
      case '.flv':
      case '.avchd':
      case '.webm':
        return VideoIcon(video: data as File?);
        break;
      case '.zip':
        return FolderLeading(
          iconData: Icons.archive,
          color: Colors.brown,
        );
        break;
      case '.jpg':
      case '.png':
      case '.gif':
      case '.jpeg':
      case '.webp':
        return LeadingImage(file: data as File?);

        break;
      case '.apk':
        return LeadingApk(future: getApkIcon(data as File?));

        break;
      case '.pdf':
        return FolderLeading(
          iconData: Icons.picture_as_pdf_sharp,
        );

        break;
      default:
        return FolderLeading(
          iconData: Icons.insert_drive_file_outlined,
        );
        break;
    }
  }

  Future<Uint8List?> getApkIcon(File? data) async {
    Uint8List? widget;

    for (final item in localApps!) {
      if (item.filePath == data!.path) {
        widget = item.icon;
        break;
      }
    }

    // widget ??= await _toShowApkIcon(data);;
    return widget;
  }
}
