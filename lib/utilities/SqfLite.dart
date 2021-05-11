import 'dart:async';
import 'dart:typed_data';

import 'package:device_apps/app_utils.dart';
import 'package:device_apps/device_apps.dart';
import 'package:files/utilities/Utils.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqfLite {
  SqfLite() {
    _init();
  }

  static const String systemAppsDatabase = 'systemApps.db';
  static const String localAppsDatabase = 'localApps.db';

  static const String systemAppsTable = 'system_apps';
  static const String localAppsTable = 'local_apps';
  static const String appName = 'app_name';
  static const String packageName = 'package_name';
  static const String apkFilePath = 'apk_file_path';
  static const String appIcon = 'app_icon';
  static Database systemApps;
  static Database localApps;

  static final Completer<void> _isReady = Completer<void>();
  static Future<void> get isReady => _isReady.future;

  Future<void> _init() async {
    if (await databaseExists(systemAppsDatabase) &&
        await databaseExists(localAppsDatabase)) {
      systemApps = await openDatabase(systemAppsDatabase);
      localApps = await openDatabase(localAppsDatabase);
      _isReady.complete();
    } else {
      var stopwatch = Stopwatch()..start();
      systemApps = await createDatabase(
        tableName: systemAppsTable,
        databaseName: systemAppsDatabase,
      );
      localApps = await createDatabase(
        tableName: localAppsTable,
        databaseName: localAppsDatabase,
      );
      await createSystemAppsTable(systemApps);
      await createLocalAppsTable(localApps);
      _isReady.complete();
      print("database took this ${stopwatch.elapsed} time");
    }
  }

  static Future<Database> createDatabase(
      {String tableName, String databaseName}) async {
    final dbDataPath = await getDatabasesPath();
    String path = join(dbDataPath, databaseName);
    final String createTable =
        'CREATE TABLE $tableName (id INTEGER PRIMARY KEY AUTOINCREMENT, $appName TEXT, $packageName TEXT, $apkFilePath TEXT, $appIcon BLOB)';
    try {
      return await openDatabase(
        path,
        version: 1,
        onCreate: (Database db, int version) async =>
            await db.execute(createTable),
      );
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<void> createLocalAppsTable(Database database) async {
    final List<String> allApps = await FileUtils.getAllLocalApps();
    print('AllApps length: ${allApps.length}');
    final appsData = await DeviceApps.getAppByApkFile(allApps);
    final List<App> apps =
        // await FileUtils.worker.doWork(App.fromList, appsData);
        App.fromList(appsData);

    try {
      final Batch batch = database.batch();
      for (var item in apps) {
        final query = await database.query(
          localAppsTable,
          where: '$apkFilePath = ?',
          whereArgs: [item.apkFilePath],
        );
        if (query.isEmpty) {
          database.insert(
            localAppsTable,
            toMap(item),
            conflictAlgorithm: ConflictAlgorithm.ignore,
          );
        }
      }
      await batch.commit();
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<void> createSystemAppsTable(Database db) async {
    var _systemApps = await DeviceApps.getInstalledApplications(
      includeAppIcons: true,
      includeSystemApps: true,
      // onlyAppsWithLaunchIntent: true,
    );
    final List<App> systemApps =
        await FileUtils.worker.doWork(App.fromList, _systemApps);
    try {
      final Batch batch = db.batch();
      for (var item in systemApps) {
        db.insert(
          systemAppsTable,
          toMap(item),
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
      }
      await batch.commit();
    } catch (e) {
      throw Exception(e);
    }
  }

  static Map<String, dynamic> toMap(App app) {
    return {
      appName: app.appName,
      packageName: app.packageName,
      apkFilePath: app.apkFilePath,
      appIcon: app.appIcon,
    };
  }

  static List<Apps> fromMap(List list) {
    return List.generate(list.length, (i) {
      final map = list[i];
      return Apps(
        filePath: map[apkFilePath],
        icon: map[appIcon],
        name: map[appName],
        packageName: map[packageName],
      );
    });
  }
}

class Apps {
  final String filePath;
  final Uint8List icon;
  final String name;
  final String packageName;

  Apps({
    this.filePath,
    this.icon,
    this.name,
    this.packageName,
  });
}
