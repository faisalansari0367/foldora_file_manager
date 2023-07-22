import 'dart:developer';

import 'package:files/services/gdrive/http_client.dart';
import 'package:files/utilities/my_snackbar.dart';
import 'package:hive/hive.dart';

import '../hive_implementation.dart';

abstract class DriveKeys {
  static const authHeaders = 'authHeaders';
  static const driveBox = 'driveBox';
}

class DriveStorage extends HiveImplementation {
  static late Box box;
  static var _isInit = false;

  DriveStorage() {
    if (_isInit) return;
    _isInit = true;
    _init(DriveKeys.driveBox);
  }

  Future<void> _init(String boxName) async {
    final box = await super.init(boxName);
    DriveStorage.box = box;
  }

  Future<void> saveClient(Map<String, String> headers) async {
    await box.put(DriveKeys.authHeaders, headers);
  }

  GoogleHttpClient getClient() {
    Map data = box.get(DriveKeys.authHeaders);
    final headers = data.cast<String, String>();
    // if (headers == null) return null;
    final client = GoogleHttpClient(headers);
    return client;
  }

  Future<void> saveDriveFiles(String id, List data) async {
    try {
      await box.put(id, data);
    } catch (e) {
      print('error occured during saving data: $e');
    }
  }

  Future<List<dynamic>?> getDriveFiles(String id) async {
    try {
      final data = await box.get(id);
      return data;
    } catch (e) {
      log('error occured during getting data: $e');
      MySnackBar.show(content: 'error occured during getting data: $e');
      return [];
    }
  }
}
