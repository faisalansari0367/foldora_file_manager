import 'dart:async';
import 'dart:developer';
import 'dart:io' as io;

import 'package:files/pages/Drive/drive_nav_rail_item.dart';
import 'package:files/services/gdrive/base_drive.dart';
import 'package:files/utilities/DataModel.dart';
import 'package:files/utilities/my_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:googleapis/drive/v3.dart';
import 'package:storage_details/storage_details.dart';

class DriveProvider extends ChangeNotifier {
  final _completer = Completer<void>();
  Future<void> get isReady async => await _completer.future;
  AboutStorageQuota driveQuota;
  bool isLoading = false;
  BuildContext context;
  final List<DriveNavRailItem> navRail = [DriveNavRailItem(name: 'Drive')];
  final filesToUpload = <io.FileSystemEntity>[];
  List<Data> storageDetails;
  int selectedIndex = 0;
  String currentPath = '/storage/emulated/0';

  var driveFiles = <File>[];

  DriveProvider() {
    _init();
  }

  void setContext(context) {
    this.context = context;
  }

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void addNavRail(String name, String id) {
    // navRail.add(DriveNavRailItem(name: name, id: id));
    navigationAddOrRemove(name, id);
    notifyListeners();
  }

  Future<void> diskSpace() async {
    final spaceInfo = await StorageDetails.getspace;
    storageDetails = Data.storageToData(spaceInfo);

    notifyListeners();
  }

  void onTap(io.FileSystemEntity entity) {
    final isDir = entity is io.Directory;
    if (isDir) {
      currentPath = entity.path;
    } else {
      if (filesToUpload.contains(entity)) {
        filesToUpload.remove(entity);
        return;
      }
      filesToUpload.add(entity);
    }
    notifyListeners();
  }

  bool isExist(List<io.FileSystemEntity> list, io.FileSystemEntity file) {
    var match = false;
    for (var item in list) {
      if (item.path == file.path) {
        match = true;
        break;
      }
    }
    return match;
  }

  void addToSelectedFiles(io.FileSystemEntity entity) {
    final isContainsFile = isExist(filesToUpload, entity);
    if (isContainsFile) {
      // final index = filesToUpload.indexOf(entity);
      filesToUpload.removeWhere((element) => element.path == entity.path);
    } else {
      filesToUpload.add(entity);
    }
    print(filesToUpload.length);
    notifyListeners();
  }

  Future<void> renewClient() async {
    // final googleSignInAccount = await Auth.initializeFirebase();
    // final client = await Auth.getClient(googleSignInAccount);
    // MyDrive(client);
  }

  Future<void> _init() async {
    await getStorageQuota();

    _completer.complete();
    await diskSpace();
    // getDriveFiles();
  }

  void setSelectedIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  // bool navRailContains(DriveNavRailItem navRailItem) {
  //   var contains = false;
  //   for (var item in navRail) {
  //     if (item.id == navRailItem.id) {
  //       contains = true;
  //       break;
  //     } else {
  //       contains = false;
  //     }
  //   }
  //   return contains;
  // }

  void removeAllAfterFirstAndAdd(DriveNavRailItem item) {
    navRail.removeRange(1, navRail.length);
    navRail.add(item);
  }

  void navigationAddOrRemove(String name, String id) {
    final navItem = DriveNavRailItem(name: name, id: id);
    final isExist = navRail.contains(navItem);
    if (!isExist) {
      if (selectedIndex == 0) {
        removeAllAfterFirstAndAdd(navItem);
      } else if (navRail.elementAt(1) != navItem && selectedIndex == 0) {
        removeAllAfterFirstAndAdd(navItem);
      } else if (navItem == navRail.elementAt(1)) {
        removeAllAfterFirstAndAdd(navItem);
      } else {
        navRail.add(navItem);
      }
    } else if (navItem != navRail.elementAt(1)) {
      removeAllAfterFirstAndAdd(navItem);
    }
    setSelectedIndex(navRail.indexOf(navItem));
    print('selected index is $selectedIndex');
  }

  Future<void> downloadFile(fileName, fileId) async {
    await MyDrive.downloadGoogleDriveFile(fileName, fileId);
  }

  Future<List<File>> getDriveFiles({fileId}) async {
    await isReady;
    try {
      print('file id is $fileId');
      setLoading(true);
      final data = await MyDrive.driveFiles(fileId: fileId);
      driveFiles = data;
      setLoading(false);

      return data;
    } catch (e) {
      MySnackBar.show(context, content: e.message);
      log(e.message);
      setLoading(false);
      return [];
    }
  }

  Future<void> getStorageQuota() async {
    setLoading(true);
    try {
      final about = await MyDrive.getDriveStorageQuota();
      driveQuota = about.storageQuota;
      notifyListeners();
    } on DetailedApiRequestError catch (e) {
      MySnackBar.show(context, content: e.message);
      await renewClient();
      // MySnackBar.show(context, content: 'Client renewed');

      await getStorageQuota();
    }
  }
}
