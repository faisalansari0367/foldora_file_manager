import 'dart:io';

import 'package:device_apps/app_utils.dart';
import 'package:device_apps/device_apps.dart';
import 'package:files/utilities/SqfLite.dart';
import 'package:files/utilities/Utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import 'LeadingIconWidgets.dart';

class IconProvider extends ChangeNotifier {
  IconProvider() {
    _init();
  }

  Future<void> _init() async {
    _initPrefs();
    _getINstalledApplications();
  }

  Database db;

  List<Apps> systemApps = [];
  List<Apps> localApps = [];

  Future<void> _getINstalledApplications() async {
    SqfLite();
    await SqfLite.isReady;
    final Database _localApps = SqfLite.localApps;
    final Database _systemApps = SqfLite.systemApps;

    final _systemAppsData = await _systemApps.query(SqfLite.systemAppsTable);
    systemApps =
        await FileUtils.worker.doWork(SqfLite.fromMap, _systemAppsData);

    final _localAppsData = await _localApps.query(SqfLite.localAppsTable);
    localApps = await FileUtils.worker.doWork(SqfLite.fromMap, _localAppsData);

    print("system apps count ${systemApps.length}");
    print("local apps count ${localApps.length}");
    notifyListeners();

    // const databaseName = SqfLite.systemAppsDatabase;
    // if (await databaseExists(databaseName)) {
    //   final Database _db = await openDatabase(databaseName);
    //   db = _db;
    // } else {
    //   var stopwatch = Stopwatch()..start();
    //   var db = await SqfLite.createDatabase(table: SqfLite.systemAppsTable);
    //   await SqfLite.createSystemAppsTable(db);
    //   await SqfLite.createLocalAppsTable(db);
    //   print(stopwatch.elapsed);
    //   _getINstalledApplications();
    // }

    // notifyListeners();
  }

  SharedPreferences _prefs;
  SharedPreferences get prefs => _prefs;

  void _initPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _prefs = prefs;
    notifyListeners();
  }

  static Widget forQueryingDatabase(
      {@required Future future, Widget initialData}) {
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
  Future<Widget> _toShowIconOnFolder(path) async {
    var stopwatch = Stopwatch()..start();
    await SqfLite.isReady;
    var widget = Widgets.folderIcons(folderIcon);
    final name = p.basename(path);
    var query = await SqfLite.systemApps.query(
      SqfLite.systemAppsTable,
      // where: "${SqfLite.packageName} = '$name' OR ${SqfLite.appName} = '$name'",
      where: "${SqfLite.packageName} = ? OR ${SqfLite.appName} = ?",
      whereArgs: [name, name],
    );
    if (query.isNotEmpty) {
      var list = SqfLite.fromMap(query);
      widget = Widgets.folderIcons(folderIcon, bytes: list[0].icon);
    }
    print(stopwatch.elapsed);
    return widget;
  }

  Future<Widget> _toShowApkIcon(path) async {
    var result = Widgets.folderIcons(Widgets.fileIcon);

    final appsData = await DeviceApps.getAppByApkFile([path]);
    if (appsData.isEmpty) return result;
    final List<App> apps = await FileUtils.worker.doWork(App.fromList, appsData);
    await SqfLite.isReady;
    SqfLite.localApps.insert(
      SqfLite.localAppsTable,
      SqfLite.toMap(apps[0]),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
    return Widgets.forImage(apps[0].appIcon);
  }

  Future<Widget> _createVideoThumbnail(path) async {
    final String filePath = await FileUtils.createThumbnail(path);
    if (filePath != null) {
      final File file = File(filePath);
      return Widgets.forImage(file);
    } else {
      return Widgets.folderIcons(Icons.videocam);
    }
  }

  Widget _showIcon(path) {
    var result = Widgets.folderIcons(folderIcon);
    final name = p.basename(path);
    for (var item in systemApps) {
      if (item.name == name || item.packageName == name) {
        result = Widgets.folderIcons(folderIcon, bytes: item.icon);
      }
    }
    return result;
  }

  switchCaseForIcons(data) {
    if (data is Directory) {
      return _showIcon(data.path);
      // return forQueryingDatabase(
      //   future: _toShowIconOnFolder(data.path),
      //   initialData: Widgets.folderIcons(folderIcon),
      // );
    } else if (data is File) {
      switch (p.extension(data.path).toLowerCase()) {
        case '.mp3':
        case '.m4a':
        case '.ac3':
        case '.aac':
        case '.3ga':
        case '.wav':
        case '.wma':
          return Widgets.folderIcons(Icons.library_music);
          break;
        case '.mp4':
        case '.mkv':
        case '.3gp':
        case '.wmv':
        case '.avi':
        case '.flv':
        case '.avchd':
        case '.webm':
          return video(data);
          break;
        case '.zip':
          return Widgets.folderIcons(Icons.archive,
              bgColor: Colors.indigo[200]);
          break;
        case '.jpg':
        case '.png':
        case '.gif':
          return Widgets.forImage(File(data.path), cacheWidth: 150);
          break;
        case '.apk':
          return caseApk(data);
          break;
        default:
          return Widgets.folderIcons(Widgets.fileIcon);
          break;
      }
    }
  }

  video(data) {
    final map = FileUtils.isVideoThumbnailExist(data.path);
    return map['isFileExist']
        ? Widgets.forImage(map['thumb'])
        : forQueryingDatabase(
            future: _createVideoThumbnail(data.path),
            initialData: Widgets.folderIcons(Icons.videocam),
          );
  }

  caseApk(data) {
    Widget widget;
    var result = Widgets.folderIcons(Widgets.fileIcon);

    for (var item in localApps) {
      if (item.filePath == data.path) {
        widget = Widgets.forImage(item.icon);
      }
    }
    if (widget == null) {
      widget = forQueryingDatabase(
        future: _toShowApkIcon(data.path),
        initialData: result,
      );
    }
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
