import 'package:ext_storage/ext_storage.dart';
import 'package:files/services/gdrive/base_drive.dart';
import 'package:flutter/cupertino.dart';
import 'package:open_file/open_file.dart';
import 'dart:io' as io;
import 'package:path/path.dart' as p;

class DriveDownloader extends ChangeNotifier {
  bool isDownloading = false;
  double percent = 0.0;
  final queue = [];
  String downloadsDirectory;
  List<io.FileSystemEntity> downloads = [];

  DriveDownloader() {
    _initDownloadDir();
  }

  Future<void> _initDownloadDir() async {
    downloadsDirectory = await ExtStorage.getExternalStoragePublicDirectory(ExtStorage.DIRECTORY_DOWNLOADS);
    final downloadDir = io.Directory(downloadsDirectory);
    downloads = await downloadDir.list().toList();
    downloadDir.watch(recursive: true).listen((event) {
      if (event.isDirectory) {
        final dir = io.Directory(event.path);
        downloads.add(dir);
      } else {
        final dir = io.File(event.path);
        downloads.add(dir);
      }
      notifyListeners();
    });
  }

  void setIsDownloading(bool value) {
    isDownloading = value;
    notifyListeners();
  }

  void setPercent(double value) {
    percent = value;
    notifyListeners();
  }

  // Future<void> downloadListener(List<int> data) async {
  //   percent += calculatePercent(data.length, totalSize);
  //   final index = queue.indexOf(map);
  //   queue.elementAt(index)['percent'] = percent;
  //   await saveFile.writeAsBytes(dataStore, mode: io.FileMode.append);
  //   notifyListeners();
  // }

  Future<void> downloadFile(String fName, String id, String fileSize) async {
    final map = {'fileName': fName, 'id': id, 'percent': 0.0};
    queue.add(map);
    notifyListeners();
    final file = await MyDrive.downloadGoogleDriveFile(fName, id);
    final saveFile = io.File('$downloadsDirectory/$fName');
    await saveFile.create();
    // var downloadFile = DownloadableFileBasic(() => 'Test string', testFile);
    // DownloadManager.instance().add(DownloadableFileBasic(() => 'Test string', testBFile));

    final totalSize = file.length ?? int.parse(fileSize);
    var percent = 0.0;
    var dataStore = <int>[];
    file.stream.listen(
      (data) async {
        percent += calculatePercent(data.length, totalSize);
        final index = queue.indexOf(map);
        queue.elementAt(index)['percent'] = percent;
        dataStore.addAll(data);
        notifyListeners();
      },
      onDone: () async {
        print('File saved at ${saveFile.path}');
        await saveFile.writeAsBytes(dataStore);
        final index = queue.indexOf(map);
        queue.removeAt(index);
        setIsDownloading(false);
      },
      onError: (error) => print('Some Error $error'),
    );
  }

  double calculatePercent(int size, int totalSize) {
    if (size == null || size <= 0 || totalSize == null) {
      return 0.0;
    }
    final percent = size / totalSize * 100;
    return percent;
  }

  bool isFileAlreadyDownloaded(String fileName) {
    var result = false;
    for (var item in downloads) {
      final itemFileName = p.basename(item.path);
      if (itemFileName.contains(fileName)) {
        OpenFile.open(item.path);
        result = true;
        break;
      }
    }
    return result;
  }
}
