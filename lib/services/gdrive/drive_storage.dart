import 'package:files/services/gdrive/http_client.dart';
import 'package:hive/hive.dart';

import '../hive_implementation.dart';

abstract class DriveKeys {
  static const authHeaders = 'authHeaders';
  static const driveBox = 'driveBox';
}

class DriveStorage extends HiveImplementation {
  static Box box;
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
    if (headers == null) return null;
    final client = GoogleHttpClient(headers);
    return client;
  }
}
