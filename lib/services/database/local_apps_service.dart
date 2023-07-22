import 'dart:async';
import 'dart:developer';

// import 'package:device_apps/app_utils.dart';
// import 'package:device_apps/device_apps.dart';
import 'package:files/models/apps.dart';
import 'package:files/services/database/sqf_interface.dart';
import 'package:files/utilities/Utils.dart';
import 'package:sqflite/sqflite.dart';

class LocalAppsService extends SqfDatabase {
  static const String _localAppsDatabase = 'localApps.db', _localAppsTable = 'local_apps';

  static final _completer = Completer<Database>();
  Future<Database> get _db async => await _completer.future;

  LocalAppsService() {
    init();
  }

  @override
  Future<void> insertData() async {
    final allApps = (await FileUtils.getAllLocalApps())!;
    print('AllApps length: ${allApps.length}');
    // final appsData = await DeviceApps.getAppByApkFile(allApps);
    // final apps = App.fromList(appsData);
    // final where = '${SqfDatabase.apkFilePath} = ?';
    // try {
    //   final database = await _db;
    //   final batch = database.batch();

    //   for (final item in apps) {
    //     final query = await database.query(_localAppsTable, where: where, whereArgs: [item.apkFilePath]);
    //     if (query.isEmpty) {
    //       batch.insert(
    //         _localAppsTable,
    //         Apps.toMap(item),
    //         conflictAlgorithm: ConflictAlgorithm.ignore,
    //       );
    //     }
    //   }
    //   await batch.commit();
    // } catch (e) {
    //   throw Exception(e);
    // }
  }

  Future<void> insert(Map<String, dynamic> data) async {
    final database = await _db;
    await database.insert(
      _localAppsTable,
      data,
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  @override
  Future<List<Apps>?> getApps() async {
    final db = await _db;
    final _localAppsData = await db.query(_localAppsTable);
    final List<Apps>? localApps = await (FileUtils.worker.doWork(Apps.fromMap, _localAppsData) as FutureOr<List<Apps>?>);
    return localApps;
  }

  @override
  Future<void> init() async {
    if (_completer.isCompleted) return;
    final stopwatch = Stopwatch()..start();
    final doesDbExist = await databaseExists(_localAppsDatabase);
    if (doesDbExist) {
      // final db = await _createDatabase(databaseName: _systemAppsDatabase, tableName: _systemAppsTable);
      final db = await openDatabase(_localAppsDatabase);
      _completer.complete(db);
      log('local apps took ${stopwatch.elapsedMilliseconds} ms to insert and create db');
      stopwatch.stop();
      return;
    }
    final db = await createDatabase(databaseName: _localAppsDatabase, tableName: _localAppsTable);
    _completer.complete(db);
    await insertData();
    log('local apps took ${stopwatch.elapsedMilliseconds} ms to insert and create db');
    stopwatch.stop();
  }
}
