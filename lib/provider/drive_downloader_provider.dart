import 'package:ext_storage/ext_storage.dart';
import 'package:files/services/gdrive/base_drive.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' as io;

class DriveDownloader extends ChangeNotifier {
  bool isDownloading = false;
  double percent = 0.0;
  final queue = [];
  void setIsDownloading(bool value) {
    isDownloading = value;
    notifyListeners();
  }

  void setPercent(double value) {
    percent = value;
    notifyListeners();
  }

  Future<void> downloadFile(String fName, String id, String fileSize) async {
    final map = {'fileName': fName, 'id': id, 'percent': 0.0};
    queue.add(map);
    final file = await MyDrive.downloadGoogleDriveFile(fName, id);

    final directory = await ExtStorage.getExternalStoragePublicDirectory(
        ExtStorage.DIRECTORY_DOWNLOADS);

    final saveFile = io.File('$directory/$fName');
    await saveFile.create();
    var dataStore = <int>[];
    var percent = 0.0;
    file.stream.listen((data) async {
      // print('dataStore: ${dataStore.length}');

      // print('DataReceived: ${data.length}');
      percent +=
          calculatePercent(data.length, file.length ?? int.parse(fileSize));
      // print('percent is ' + percent.toString());

      final index = queue.indexOf(map);
      queue.elementAt(index)['percent'] = percent;
      // dataStore.insertAll(dataStore.length, data);
      await saveFile.writeAsBytes(dataStore, mode: io.FileMode.append);
      notifyListeners();
    }, onDone: () {
      print('Task Done');
      // saveFile.writeAsBytes(dataStore);
      print('File saved at ${saveFile.path}');
      final index = queue.indexOf(map);
      queue.removeAt(index);
      setIsDownloading(false);
      // setPercent(0.0);
    }, onError: (error) {
      print('Some Error $error');
    });
  }

  double calculatePercent(int size, int totalSize) {
    if (size == null || size <= 0 || totalSize == null) {
      return 0.0;
    }
    final percent = size / totalSize * 100;
    return percent;
  }
}
