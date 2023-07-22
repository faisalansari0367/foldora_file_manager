import 'package:files/services/gdrive/base_drive.dart';
import 'package:flutter/material.dart';

class DriveDeleter extends ChangeNotifier {
  List<String?> _fileIds = <String>[];
  List<String?> get fileIds => _fileIds;

  DriveDeleter();

  void addAndRemoveFile(String? id) {
    // _fileIds.contains(id) ?  : _filesIds = [..._fileIds, id];
    if (fileIds.contains(id)) {
      final ids = [...fileIds];
      ids.remove(id);
      _fileIds = [...ids];
    } else {
      _fileIds = [..._fileIds, id];
    }
    print(_fileIds);
    notifyListeners();
  }

  Future<bool> deleteFiles() async => await MyDrive.deleteFiles(_fileIds);
}
