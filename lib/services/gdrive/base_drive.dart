import 'package:googleapis/drive/v3.dart';
import 'package:http/http.dart';

class MyDrive {
  static DriveApi drive;

  MyDrive(Client client) {
    final drive = DriveApi(client);
    MyDrive.drive = drive;
  }

  static Future<List<File>> driveFiles() async {
    try {
      final files = await drive.files.list();
      return files.files;
    } catch (e) {
      rethrow;
    }
  }

  static Future<About> getDriveStorageQuota() async {
    try {
      final about = await drive.about.get($fields: '*');
      return about;
    } catch (e) {
      rethrow;
    }
  }
}
