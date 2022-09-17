import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static Future<bool> storage() async {
    final request = await Permission.storage.request();
    return request.isGranted;
  }

  static Future<bool> accessAllFiles() async {
    final request = await Permission.manageExternalStorage.request();
    return request.isGranted;
  }
}
