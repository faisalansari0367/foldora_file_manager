import 'dart:io';

import 'package:device_apps/app_utils.dart';
import 'package:device_apps/device_apps.dart';
import 'package:files/utilities/SqfLite.dart';
import 'package:files/utilities/Utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import 'LeadingIconWidgets.dart';

class IconProvider extends ChangeNotifier {
  SharedPreferences _prefs;
  SharedPreferences get prefs => _prefs;
  Database db;
  List<Apps> systemApps = [];
  List<Apps> localApps = [];

  IconProvider() {
    _init();
  }

  Future<void> _init() async {
    await _initPrefs();
    await _getINstalledApplications();
  }

  Future<void> _getINstalledApplications() async {
    SqfLite();
    await SqfLite.isReady;
    final _localApps = SqfLite.localApps;
    final _systemApps = SqfLite.systemApps;

    final _systemAppsData = await _systemApps.query(SqfLite.systemAppsTable);
    systemApps = await FileUtils.worker.doWork(SqfLite.fromMap, _systemAppsData);

    final _localAppsData = await _localApps.query(SqfLite.localAppsTable);
    localApps = await FileUtils.worker.doWork(SqfLite.fromMap, _localAppsData);

    print('system apps count ${systemApps.length}');
    print('local apps count ${localApps.length}');
    notifyListeners();
  }

  Future<void> _initPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _prefs = prefs;
    notifyListeners();
  }

  static Widget forQueryingDatabase({@required Future future, Widget initialData}) {
    return FutureBuilder<Widget>(
      future: future,
      initialData: initialData,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return snapshot.data is Widget ? snapshot.data : initialData;
        } else {
          return initialData;
        }
      },
    );
  }

  static final IconData folderIcon = Icons.folder_open;

  Future<Widget> _toShowApkIcon(path, {iconBgColor, iconColor, decoration}) async {
    final result = Widgets.folderIcons(
      Widgets.fileIcon,
      bgColor: iconBgColor,
      iconColor: iconColor,
      decoration: decoration,
    );

    final appsData = await DeviceApps.getAppByApkFile([path.path]);
    if (appsData.isEmpty) return result;
    final List<App> apps = await FileUtils.worker.doWork(App.fromList, appsData);
    await SqfLite.isReady;
    await SqfLite.localApps.insert(
      SqfLite.localAppsTable,
      SqfLite.toMap(apps[0]),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
    return Widgets.forImage(apps[0].appIcon);
  }

  Future<Widget> _createVideoThumbnail(path, {iconBgColor, iconColor, decoration, radius}) async {
    String filePath;
    try {
      filePath = await FileUtils.createThumbnail(path);
    } catch (e) {
      await Fluttertoast.showToast(msg: e.toString());
    }
    if (filePath != null) {
      final file = File(filePath);
      return Widgets.forImage(
        file,
        decoration: decoration,
        radius: radius,
      );
    } else {
      return Widgets.folderIcons(
        Icons.videocam,
        bgColor: iconBgColor,
        iconColor: iconColor,
        decoration: decoration,
      );
    }
  }

  Widget _showIcon(String path, {Color bgColor, Color iconColor, decoration}) {
    var result = Widgets.folderIcons(
      folderIcon,
      bgColor: bgColor,
      iconColor: iconColor,
      decoration: decoration,
    );
    final name = p.basename(path);
    for (final item in systemApps) {
      if (item.name == name || item.packageName == name) {
        result = Widgets.folderIcons(
          folderIcon,
          bytes: item.icon,
          bgColor: bgColor,
          iconColor: iconColor,
          decoration: decoration,
        );
        break;
      }
    }
    return result;
  }

  Widget switchCaseForIcons(FileSystemEntity data,
      {Color iconBgColor, Color iconColor, BoxDecoration decoration, double imageRadius}) {
    if (data is Directory) {
      return _showIcon(
        data.path,
        bgColor: iconBgColor,
        iconColor: iconColor,
        decoration: decoration,
      );
    }
    switch (p.extension(data.path).toLowerCase()) {
      case '.mp3':
      case '.m4a':
      case '.ac3':
      case '.aac':
      case '.3ga':
      case '.wav':
      case '.wma':
        return Widgets.folderIcons(
          Icons.library_music,
          bgColor: iconBgColor ?? Colors.orange[800],
          iconColor: iconColor,
          decoration: decoration,
        );
        break;
      case '.mp4':
      case '.mkv':
      case '.3gp':
      case '.wmv':
      case '.avi':
      case '.flv':
      case '.avchd':
      case '.webm':
        return video(
          data,
          iconBgColor: iconBgColor,
          iconColor: iconColor,
          decoration: decoration,
          imageRadius: imageRadius,
        );
        break;
      case '.zip':
        return Widgets.folderIcons(
          Icons.archive,
          bgColor: iconBgColor ?? Colors.brown,
          iconColor: iconColor,
          decoration: decoration,
        );
        break;
      case '.jpg':
      case '.png':
      case '.gif':
      case '.jpeg':
      case '.webp':
        return Widgets.forImage(
          File(data.path),
          cacheWidth: 150,
          decoration: decoration,
          radius: imageRadius,
        );
        break;
      case '.apk':
        return caseApk(
          data,
          iconBgColor: iconBgColor,
          iconColor: iconColor,
          decoration: decoration,
          radius: imageRadius,
        );
        break;
      case '.pdf':
        return Widgets.folderIcons(
          Icons.picture_as_pdf_sharp,
          bgColor: iconBgColor ?? Colors.red[400],
          iconColor: iconColor,
          decoration: decoration,
        );
        break;
      default:
        return Widgets.folderIcons(
          Widgets.fileIcon,
          bgColor: iconBgColor,
          iconColor: iconColor,
          decoration: decoration,
        );
        break;
    }
  }

  Widget video(data, {iconBgColor, iconColor, decoration, imageRadius}) {
    final map = FileUtils.isVideoThumbnailExist(data.file);
    return map['isFileExist']
        ? Widgets.forImage(map['thumb'], decoration: decoration, radius: imageRadius)
        : forQueryingDatabase(
            future: _createVideoThumbnail(data.file, decoration: decoration, radius: imageRadius),
            initialData:
                Widgets.folderIcons(Icons.videocam, bgColor: iconBgColor, iconColor: iconColor, decoration: decoration),
          );
  }

  Widget caseApk(data, {iconBgColor, iconColor, decoration, double radius}) {
    Widget widget;
    final result =
        Widgets.folderIcons(Widgets.fileIcon, bgColor: iconBgColor, iconColor: iconColor, decoration: decoration);

    for (final item in localApps) {
      if (item.filePath == data.path) {
        widget = Widgets.forImage(item.icon, radius: 10);
      }
    }
    widget ??= forQueryingDatabase(
      future: _toShowApkIcon(data),
      initialData: result,
    );
    return widget;
  }

  // for (var item in apps) {
  //   if (item.filePath == data.path) {
  //     result = Widgets.forImage(item.icon);
  //   }
  // }

  // final jsonPackageInfo = prefs?.getString(data.path);

  // if (jsonPackageInfo == null) {
  //   makeApkFile(data.path);
  //   result = Widgets.folderIcons(Widgets.fileIcon);
  // } else {
  //   final json = jsonDecode(jsonPackageInfo);
  //   final Uint8List appIcon = base64Decode(json['appIcon']);
  //   result = Widgets.forImage(appIcon);
  // }
  // } catch (e) {
  // print(e);
  // }

  // if (result != null) {
  //   return result;
  // } else {
  //   makeApkFile(data.path);
  //   return Widgets.folderIcons(Widgets.fileIcon);
  // }
  // return result != null ? result : folderIcons(Widgets.fileIcon);
  // return result;

  // void makeApkFile(path) async {
  //   try {
  //     final PackageInfo packageInfo =
  //         await FlutterPackageManager.getPackageInfoByApkFile(path);
  //     if (packageInfo != null) {
  //       final object = {
  //         'packageName': packageInfo.packageName,
  //         'appName': packageInfo.appName,
  //         'appIcon': packageInfo.appIconByteArray,
  //       };
  //       final json = jsonEncode(object);
  //       await prefs.setString(path, json);
  //       await prefs.setString(object['packageName'], object['appIcon']);
  //       await prefs.setString(object['appName'], object['appIcon']);
  //       notifyListeners();
  //     }
  //   } catch (e) {
  //     Exception(e);
  //   }
  // }
}
