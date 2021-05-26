import 'dart:async';
import 'dart:io';
import 'package:files/utilities/DataModel.dart';
import 'package:files/utilities/Utils.dart';
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
    init();
    FileUtils();
  }

  void init() async {
    await diskSpace();
    initSharedPreferences();
    // fileSystemEntitywatcher();
  }

  List<Storage> spaceInfo = [];

  String _dirPath = '/storage/emulated/0';

  // double _totalDiskSpace = 0;
  // double _freeDiskSpace = 0;
  bool _showHidden = false;

  SharedPreferences _prefs;
  SharedPreferences get prefs => _prefs;

  List<Data> data = [];
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
    return await Directory(data[currentPage].path).list().toList();
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
    spaceInfo = await StorageDetails.getspace;
    data = Data.storageToData(spaceInfo);
    notifyListeners();
  }

  /// Only use this function for CircleChartAndFilePercent..
  String calculatePercent(int bytes, int decimals) {
    if (data.length == 0) return '0.0';
    final _data = data[currentPage];
    double percent = bytes / ((_data.total - _data.free)) * 100;
    final result = percent.isNaN ? "0.0" : percent.toStringAsFixed(decimals);
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

  void navigationAddOrRemove(List<String> list, String path) {
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
