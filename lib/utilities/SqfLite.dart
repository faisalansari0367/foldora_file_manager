// import 'dart:async';
// import 'dart:async';
// import 'dart:developer';
// import 'dart:typed_data';

// import 'package:device_apps/app_utils.dart';
// import 'package:device_apps/device_apps.dart';
// import 'package:files/pages/Videos/models/apps.dart';
// import 'package:files/utilities/Utils.dart';
// import 'package:flutter/foundation.dart';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';

// abstract class SqfInterface {
//   Future<Database> _createDatabase({
//     @required String databaseName,
//     @required String tableName,
//   });
//   Future<void> _insertData();
//   Future<void> _init();
//   Future<List<Apps>> getApps();
// }

// class SqfDatabase extends SqfInterface {
//   static const appName = 'app_name', packageName = 'package_name', apkFilePath = 'apk_file_path', appIcon = 'app_icon';
//   @override
//   Future<Database> _createDatabase({String databaseName, String tableName}) async {
//     // final doesDbExist = await databaseExists(databaseName);
//     // if (doesDbExist) {
//     //   final db = await openDatabase(databaseName);
//     //   return db;
//     // }

//     final dbDataPath = await getDatabasesPath();
//     final path = join(dbDataPath, databaseName);

//     const appName = 'app_name', packageName = 'package_name', apkFilePath = 'apk_file_path', appIcon = 'app_icon';

//     final table = '''
//         CREATE TABLE $tableName (
//           id INTEGER PRIMARY KEY AUTOINCREMENT,
//           $appName TEXT, 
//           $packageName TEXT, 
//           $apkFilePath TEXT, 
//           $appIcon BLOB
//         )
//       ''';
//     try {
//       return await openDatabase(path,
//           version: 1, onCreate: (Database db, int version) async => await db.execute(table));
//     } catch (e) {
//       throw Exception(e);
//     }
//   }

//   @override
//   Future<void> _init() {
//     throw UnimplementedError();
//   }

//   @override
//   Future<void> _insertData() {
//     throw UnimplementedError();
//   }

//   @override
//   Future<List<Apps>> getApps() {
//     throw UnimplementedError();
//   }
// }

// class SystemApps extends SqfDatabase {
//   static const String _systemAppsDatabase = 'systemApps.db';
//   static const String _systemAppsTable = 'system_apps';
//   static final _completer = Completer<Database>();
//   Future<Database> get _db async => await _completer.future;

//   SystemApps() {
//     _init();
//   }

//   @override
//   Future<void> _init() async {
//     if (_completer.isCompleted) return;
//     final stopwatch = Stopwatch()..start();
//     final doesDbExist = await databaseExists(_systemAppsDatabase);
//     if (doesDbExist) {
//       final db = await openDatabase(_systemAppsDatabase);
//       _completer.complete(db);
      
//       return;
//     }

//     final db = await _createDatabase(databaseName: _systemAppsDatabase, tableName: _systemAppsTable);
//     _completer.complete(db);
//     await _insertData();
//     log('system apps took ${stopwatch.elapsedMilliseconds} ms to insert and create db');
//     stopwatch.stop();
//   }

//   @override
//   Future<void> _insertData() async {
//     final _systemApps = await DeviceApps.getInstalledApplications(includeAppIcons: true, includeSystemApps: true);
//     final List<App> systemApps = await FileUtils.worker.doWork(App.fromList, _systemApps);
//     try {
//       final db = await _db;
//       final batch = db.batch();
//       for (final item in systemApps) {
//         batch.insert(
//           _systemAppsTable,
//           Apps.toMap(item),
//           conflictAlgorithm: ConflictAlgorithm.ignore,
//         );
//       }
//       await batch.commit();
//     } catch (e) {
//       throw Exception(e);
//     }
//   }

//   @override
//   Future<List<Apps>> getApps() async {
//     final _systemAppsData = await (await _db).query(_systemAppsTable);
//     final List<Apps> systemApps = await FileUtils.worker.doWork(Apps.fromMap, _systemAppsData);
//     return systemApps;
//   }
// }

// // abstract class LocalDb {
// // Future<void> _init();
// // Future<void> _insertData();
// // }

// // class LocalApps extends SqfDatabase {
// //   static const String _localAppsDatabase = 'localApps.db', _localAppsTable = 'local_apps';

// //   static final _completer = Completer<Database>();
// //   Future<Database> get _db async => await _completer.future;

// //   LocalApps() {
// //     _init();
// //   }

// //   @override
// //   Future<void> _insertData() async {
// //     final allApps = await FileUtils.getAllLocalApps();
// //     print('AllApps length: ${allApps.length}');
// //     final appsData = await DeviceApps.getAppByApkFile(allApps);
// //     final apps = App.fromList(appsData);
// //     final where = '${SqfDatabase.apkFilePath} = ?';
// //     try {
// //       final database = await _db;
// //       final batch = database.batch();

// //       for (final item in apps) {
// //         final query = await database.query(_localAppsTable, where: where, whereArgs: [item.apkFilePath]);
// //         if (query.isEmpty) {
// //           batch.insert(
// //             _localAppsTable,
// //             Apps.toMap(item),
// //             conflictAlgorithm: ConflictAlgorithm.ignore,
// //           );
// //         }
// //       }
// //       await batch.commit();
// //     } catch (e) {
// //       throw Exception(e);
// //     }
// //   }

// //   Future<void> insert(Map<String, dynamic> data) async {
// //     final database = await _db;
// //     await database.insert(
// //       _localAppsTable,
// //       data,
// //       conflictAlgorithm: ConflictAlgorithm.ignore,
// //     );
// //   }

// //   @override
// //   Future<List<Apps>> getApps() async {
// //     final db = await _db;
// //     final _localAppsData = await db.query(_localAppsTable);
// //     final List<Apps> localApps = await FileUtils.worker.doWork(Apps.fromMap, _localAppsData);
// //     return localApps;
// //   }

// //   @override
// //   Future<void> _init() async {
// //     if (_completer.isCompleted) return;
// //     final stopwatch = Stopwatch()..start();
// //     final doesDbExist = await databaseExists(_localAppsDatabase);
// //     if (doesDbExist) {
// //       // final db = await _createDatabase(databaseName: _systemAppsDatabase, tableName: _systemAppsTable);
// //       final db = await openDatabase(_localAppsDatabase);
// //       _completer.complete(db);
// //       log('local apps took ${stopwatch.elapsedMilliseconds} ms to insert and create db');
// //       stopwatch.stop();
// //       return;
// //     }
// //     final db = await _createDatabase(databaseName: _localAppsDatabase, tableName: _localAppsTable);
// //     _completer.complete(db);
// //     await _insertData();
// //     log('local apps took ${stopwatch.elapsedMilliseconds} ms to insert and create db');
// //     stopwatch.stop();
// //   }
// // }

// // abstract class AppsInterface {
// //   Future<Apps> localApps();
// //   Future<Apps> systemApps();
// // }

// // class AppsDb extends AppsInterface {
// //   @override
// //   Future<Apps> localApps() {
// //     throw UnimplementedError();
// //   }

// //   @override
// //   Future<Apps> systemApps() {
// //     throw UnimplementedError();
// //   }

// // }

// // class SqfLite {
// //   SqfLite() {
// //     _init();
// //   }

// //   static const String systemAppsDatabase = 'systemApps.db';
// //   static const String localAppsDatabase = 'localApps.db';

// //   static const String systemAppsTable = 'system_apps';
// //   static const String localAppsTable = 'local_apps';
// //   static const String appName = 'app_name';
// //   static const String packageName = 'package_name';
// //   static const String apkFilePath = 'apk_file_path';
// //   static const String appIcon = 'app_icon';
// //   static Database systemApps;
// //   static Database localApps;

// //   static final Completer<void> _isReady = Completer<void>();
// //   static Future<void> get isReady => _isReady.future;

// //   Future<void> _init() async {
// //     if (await databaseExists(systemAppsDatabase) && await databaseExists(localAppsDatabase)) {
// //       systemApps = await openDatabase(systemAppsDatabase);
// //       localApps = await openDatabase(localAppsDatabase);
// //       _isReady.complete();
// //     } else {
// //       final stopwatch = Stopwatch()..start();
// //       systemApps = await createDatabase(
// //         tableName: systemAppsTable,
// //         databaseName: systemAppsDatabase,
// //       );
// //       localApps = await createDatabase(
// //         tableName: localAppsTable,
// //         databaseName: localAppsDatabase,
// //       );
// //       await createSystemAppsTable(systemApps);
// //       await createLocalAppsTable(localApps);
// //       _isReady.complete();
// //       log('database took this ${stopwatch.elapsedMilliseconds} time to create');
// //       stopwatch.stop();
// //       // stopwatch
// //     }
// //   }

// //   static Future<Database> createDatabase({String tableName, String databaseName}) async {
// //     final dbDataPath = await getDatabasesPath();
// //     final path = join(dbDataPath, databaseName);
// //     final createTable = '''
// //           CREATE TABLE $tableName (
// //             id INTEGER PRIMARY KEY AUTOINCREMENT,
// //             $appName TEXT, 
// //             $packageName TEXT, 
// //             $apkFilePath TEXT, 
// //             $appIcon BLOB
// //           )
// //         ''';
// //     try {
// //       return await openDatabase(path,
// //           version: 1, onCreate: (Database db, int version) async => await db.execute(createTable));
// //     } catch (e) {
// //       throw Exception(e);
// //     }
// //   }

// //   static Future<void> createLocalAppsTable(Database database) async {
// //     final allApps = await FileUtils.getAllLocalApps();
// //     print('AllApps length: ${allApps.length}');
// //     final appsData = await DeviceApps.getAppByApkFile(allApps);
// //     final apps = App.fromList(appsData);
// //     final where = '$apkFilePath = ?';
// //     try {
// //       final batch = database.batch();

// //       for (final item in apps) {
// //         final query = await database.query(localAppsTable, where: where, whereArgs: [item.apkFilePath]);
// //         if (query.isEmpty) {
// //           await database.insert(
// //             localAppsTable,
// //             Apps.toMap(item),
// //             conflictAlgorithm: ConflictAlgorithm.ignore,
// //           );
// //         }
// //       }
// //       await batch.commit();
// //     } catch (e) {
// //       throw Exception(e);
// //     }
// //   }

// //   static Future<void> createSystemAppsTable(Database db) async {
// //     final _systemApps = await DeviceApps.getInstalledApplications(
// //       includeAppIcons: true,
// //       includeSystemApps: true,
// //       // onlyAppsWithLaunchIntent: true,
// //     );
// //     final List<App> systemApps = await FileUtils.worker.doWork(App.fromList, _systemApps);
// //     try {
// //       final batch = db.batch();
// //       for (final item in systemApps) {
// //         await db.insert(
// //           systemAppsTable,
// //           Apps.toMap(item),
// //           conflictAlgorithm: ConflictAlgorithm.ignore,
// //         );
// //       }
// //       await batch.commit();
// //     } catch (e) {
// //       throw Exception(e);
// //     }
// //   }

//   // static Map<String, dynamic> toMap(App app) {
//   //   return {
//   //     appName: app.appName,
//   //     packageName: app.packageName,
//   //     apkFilePath: app.apkFilePath,
//   //     appIcon: app.appIcon,
//   //   };
//   // }

//   // static List<Apps> fromMap(List list) {
//   //   return List.generate(list.length, (i) {
//   //     final map = list[i];
//   //     return Apps(
//   //       filePath: map[apkFilePath],
//   //       icon: map[appIcon],
//   //       name: map[appName],
//   //       packageName: map[packageName],
//   //     );
//   //   });
//   // }
// // }
