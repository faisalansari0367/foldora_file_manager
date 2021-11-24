import 'package:googleapis/drive/v3.dart';
import 'package:http/http.dart';

class MyDrive {
  static DriveApi drive;

  MyDrive(Client client) {
    final drive = DriveApi(client);
    MyDrive.drive = drive;
  }

  static Future<List<File>> driveFiles({fileId}) async {
    var files;
    try {
      if (fileId != null) {
        files = await drive.files.list(
          // driveId: fileId,
          q: '$fileId in parents',
          supportsAllDrives: true,
          includeItemsFromAllDrives: true,
          // corpora: 'drive',
          // supportsAllDrives: true,
        );
        return files.files;
      }
      files = await drive.files.list();
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
