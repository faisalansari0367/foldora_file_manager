// ignore_for_file: unused_element

import 'package:files/models/apps.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
abstract class SqfInterface {
  Future<Database> createDatabase({
    @required String databaseName,
    @required String tableName,
  });
  Future<void> insertData();
  Future<void> init();
  Future<List<Apps>> getApps();
}

class SqfDatabase extends SqfInterface {
  static const appName = 'app_name', packageName = 'package_name', apkFilePath = 'apk_file_path', appIcon = 'app_icon';
  @override
  Future<Database> createDatabase({String databaseName, String tableName}) async {
    // final doesDbExist = await databaseExists(databaseName);
    // if (doesDbExist) {
    //   final db = await openDatabase(databaseName);
    //   return db;
    // }

    final dbDataPath = await getDatabasesPath();
    final path = join(dbDataPath, databaseName);

    const appName = 'app_name', packageName = 'package_name', apkFilePath = 'apk_file_path', appIcon = 'app_icon';

    final table = '''
        CREATE TABLE $tableName (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          $appName TEXT, 
          $packageName TEXT, 
          $apkFilePath TEXT, 
          $appIcon BLOB
        )
      ''';
    try {
      return await openDatabase(path,
          version: 1, onCreate: (Database db, int version) async => await db.execute(table));
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> init() {
    throw UnimplementedError();
  }

  @override
  Future<void> insertData() {
    throw UnimplementedError();
  }

  @override
  Future<List<Apps>> getApps() {
    throw UnimplementedError();
  }
}