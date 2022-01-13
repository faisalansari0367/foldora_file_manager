import 'dart:async';
import 'dart:developer';
import 'dart:io' as io;

import 'package:files/utilities/my_snackbar.dart';
import 'package:googleapis/drive/v3.dart';
import 'package:http/http.dart';
import 'package:path/path.dart' as path;

class MyDrive {
  static DriveApi drive;
  static bool isReady = false;
  static const mimeTypeFolder = 'application/vnd.google-apps.folder';

  MyDrive(Client client) {
    isReady = true;
    final drive = DriveApi(client);

    MyDrive.drive = drive;
  }

  static Future<List<File>> driveFiles({fileId, showAllFiles = false}) async {
    // var files;
    final idNotNull = fileId != null;
    final listFolders = "mimeType='$mimeTypeFolder'";
    final listFiles = "'$fileId' in parents";

    final whenIdIsNull = showAllFiles ? null : listFolders;
    final q = idNotNull ? listFiles : whenIdIsNull;

    // we only need iconLink, fileFUllExtension, name, size, createdTime,
    try {
      log('getting drive files...');
      final files = await drive.files.list(
        q: q,
        $fields: '*',
        supportsAllDrives: idNotNull,
        includeItemsFromAllDrives: idNotNull,
      );
      return files.files;
    } catch (e) {
      log('getting drive files error: $e');
      rethrow;
    }
  }

  static Future<bool> deleteFiles(List<String> ids) async {
    try {
      for (var id in ids) {
        print('deleting file $id');
        await drive.files.delete(id);
        print('file $id deleted');
      }
      return true;
    } catch (e) {
      MySnackBar.show(content: e.message);
      return false;
    }
  }

  static Future<About> getDriveStorageQuota() async {
    log('getting storage quota...');
    try {
      final about = await drive.about.get($fields: '*');
      return about;
    } catch (e) {
      log('error during getting storage quota: $e');
      rethrow;
    }
  }

  static Future<Media> downloadGoogleDriveFile(String fName, String gdID) async {
    final options = DownloadOptions.fullMedia;
    final Media file = await drive.files.get(gdID, downloadOptions: options);
    return file;
  }

  static void uploadFileToGoogleDrive(io.File file) async {
    var fileToUpload = File();
    fileToUpload.name = path.basename(file.absolute.path);
    final media = Media(file.openRead(), file.lengthSync());
    var response = await drive.files.create(fileToUpload, uploadMedia: media);
    print(response);
  }

  static Future<File> createDir(io.Directory dir) async {
    var file = File();
    file.mimeType = mimeTypeFolder;
    file.name = path.basename(dir.path);
    final createdFile = await drive.files.create(file);
    return createdFile;
  }
}
