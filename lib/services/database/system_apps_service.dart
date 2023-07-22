import 'dart:async';
import 'dart:developer';

// import 'package:device_apps/app_utils.dart';
// import 'package:device_apps/device_apps.dart';
import 'package:files/models/apps.dart';
import 'package:files/services/database/sqf_interface.dart';
import 'package:files/utilities/Utils.dart';
import 'package:sqflite/sqflite.dart';

class SystemAppsService extends SqfDatabase {
  static const String _systemAppsDatabase = 'systemApps.db';
  static const String _systemAppsTable = 'system_apps';
  static final _completer = Completer<Database>();
  Future<Database> get _db async => await _completer.future;

  SystemAppsService() {
    init();
  }

  @override
  Future<void> init() async {
    if (_completer.isCompleted) return;
    final stopwatch = Stopwatch()..start();
    final doesDbExist = await databaseExists(_systemAppsDatabase);
    if (doesDbExist) {
      final db = await openDatabase(_systemAppsDatabase);
      _completer.complete(db);
      
      return;
    }

    final db = await createDatabase(databaseName: _systemAppsDatabase, tableName: _systemAppsTable);
    _completer.complete(db);
    await insertData();
    log('system apps took ${stopwatch.elapsedMilliseconds} ms to insert and create db');
    stopwatch.stop();
  }

  @override
  Future<void> insertData() async {
    // final _systemApps = await DeviceApps.getInstalledApplications(includeAppIcons: true, includeSystemApps: true);
    // final List<App> systemApps = await FileUtils.worker.doWork(App.fromList, _systemApps);
    // try {
    //   final db = await _db;
    //   final batch = db.batch();
    //   for (final item in systemApps) {
    //     batch.insert(
    //       _systemAppsTable,
    //       Apps.toMap(item),
    //       conflictAlgorithm: ConflictAlgorithm.ignore,
    //     );
    //   }
    //   await batch.commit();
    // } catch (e) {
    //   throw Exception(e);
    // }
  }

  @override
  Future<List<Apps>?> getApps() async {
    final _systemAppsData = await (await _db).query(_systemAppsTable);
    final List<Apps>? systemApps = await (FileUtils.worker.doWork(Apps.fromMap, _systemAppsData) as FutureOr<List<Apps>?>);
    return systemApps;
  }
}