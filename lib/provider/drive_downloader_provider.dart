import 'package:ext_storage/ext_storage.dart';
import 'package:files/services/gdrive/base_drive.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' as io;

class DriveDownloader extends ChangeNotifier {
  bool isDownloading = false;
  double percent = 0.0;
  final queue = [];
  String downloadsDirectory;

  DriveDownloader() {
    _initDownloadDir();
  }

  Future<void> _initDownloadDir() async {
    downloadsDirectory = await ExtStorage.getExternalStoragePublicDirectory(
        ExtStorage.DIRECTORY_DOWNLOADS);
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
    final totalSize = file.length ?? int.parse(fileSize);
    var percent = 0.0;

    file.stream.listen(
      (data) async {
        percent += calculatePercent(data.length, totalSize);
        final index = queue.indexOf(map);
        queue.elementAt(index)['percent'] = percent;
        await saveFile.writeAsBytes(data, mode: io.FileMode.append);
        notifyListeners();
      },
      onDone: () {
        print('File saved at ${saveFile.path}');
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
}
