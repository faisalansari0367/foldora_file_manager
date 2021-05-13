import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:disk_space/disk_space.dart';
import 'package:files/utilities/DataModel.dart';
import 'package:files/utilities/Utils.dart';
// import 'package:files/utilities/storage_space.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:path/path.dart' as p;
import 'package:storage_details/storage_details.dart';

import '../sizeConfig.dart';

class MyProvider extends ChangeNotifier {
  MyProvider() {
    FileUtils();
    init();
  }

  void init() async {
    // await getPermission();
    await diskSpace();
    initSharedPreferences();
    // fileSystemEntitywatcher();
  }

  List<Storage> spaceInfo = [];

  String _dirPath = '/storage/emulated/0';

  double _totalDiskSpace = 0;
  double _freeDiskSpace = 0;
  bool _showHidden = false;

  SharedPreferences _prefs;
  SharedPreferences get prefs => _prefs;

  List<Data> data = [];
  double get getTotalDiskSpace => _totalDiskSpace * pow(1024, 2);
  double get getFreeDiskSpace => _freeDiskSpace * pow(1024, 2);
  String get getDirPath => _dirPath;
  bool get showHidden => _showHidden;

  double appbarSize = 6.25 * Responsive.heightMultiplier;
  bool showBottomAppbar = true;

  void scrollListener(ScrollController controller) {
    var direction = controller.position.userScrollDirection;
    if (direction == ScrollDirection.forward) {
      appbarSize = 12.5 * Responsive.heightMultiplier;
      notifyListeners();
    }
  }

  void initSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _prefs = prefs;
    notifyListeners();
  }

  Future<List<FileSystemEntity>> files() async {
    return await Directory(data[0].path).list().toList();
  }

  Future<PermissionStatus> getPermission() async {
    final storage = Permission.storage;
    if (!await storage.request().isGranted) {
      await storage.request();
    }
    return await storage.status;
  }

  Future<void> createFileSystemEntity(String path, String name) async {
    final folderPath = p.join(path, name);
    try {
      if (p.extension(folderPath) != '') {
        File(folderPath)..create();
      } else {
        Directory(folderPath)..create();
        print(folderPath);
      }
      // notifyListeners();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> rename(FileSystemEntity item, String name) async {
    final newPath = item.path.replaceAll(p.basename(item.path), name);
    await item.rename(newPath);
  }

  Future<void> diskSpace() async {
    _totalDiskSpace = await DiskSpace.getTotalDiskSpace;
    _freeDiskSpace = await DiskSpace.getFreeDiskSpace;
    spaceInfo = await StorageDetails.getspace;
    data = Data.storageToData(spaceInfo);
    notifyListeners();
  }

  /// Only use this function for CircleChartAndFilePercent..
  String calculatePercent(int bytes, int decimals) {
    double percent = bytes / ((getTotalDiskSpace - getFreeDiskSpace)) * 100;
    final String result =
        percent.isNaN ? "0.0" : percent.toStringAsFixed(decimals);
    return result;
  }

  void toggleHidden() {
    _showHidden = !_showHidden;
    notifyListeners();
  }

  Future<List<FileSystemEntity>> dirContents(String path,
      {isShowHidden: false}) async {
    Map args = {'path': path, 'showHidden': isShowHidden};
    try {
      // final result = FileUtils.directoryList(args);
      final result =
          await FileUtils.worker.doWork(FileUtils.directoryList, args);
      return result;
    } catch (e) {
      throw e;
    }
  }

  void fileSystemEntitywatcher() {
    StorageDetails.watchFilesForChanges.listen((event) {
      print(event);
      notifyListeners();
    });
  }

  int currentPage = 0;
  void onPageChanged(value) {
    currentPage = value;
    notifyListeners();
  }

  void ontap(FileSystemEntity dir) {
    if (dir is Directory) {
      data[currentPage].currentPath = dir.path;
      addPath(dir.path);
    } else {
      OpenFile.open(dir.path);
    }
    notifyListeners();
  }

  onGoBack(context) {
    final value = data[currentPage];
    if (value.currentPath == value.path) {
      return Navigator.pop(context);
    } else {
      value.currentPath = Directory(value.currentPath).parent.path;
    }
    notifyListeners();
  }

  List<String> getListOfNavigation() {
    return data[currentPage]?.navItems;
  }

  void addPath(String path) {
    navigationAddOrRemove(data[currentPage].navItems, path);
    notifyListeners();
  }

  void navigationAddOrRemove(List<String> list, path) {
    final parentDir = Directory(path).parent.path;
    if (!list.contains(path)) {
      if (list.last == parentDir) {
        list.add(path);
      } else if (Directory(list.last).parent.path == parentDir) {
        list.removeLast();
        list.add(path);
      } else {
        list.removeRange(1, list.length);
        list.add(path);
      }
    }
  }
}
