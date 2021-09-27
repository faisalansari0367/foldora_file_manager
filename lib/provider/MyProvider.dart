import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:files/utilities/DataModel.dart';
import 'package:files/utilities/Utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';
import 'package:storage_details/storage_details.dart';

class MyProvider extends ChangeNotifier {
  Function scrollListener;

  int currentPage = 0;

  // }

  List<Storage> spaceInfo = [];
  bool _showHidden = false;
  // SharedPreferences _prefs;
  List<Data> data = [];
  MyProvider() {
    init();
    // StorageDetails.watchFilesForChanges.listen((dynamic event) {
    //   print(event);
    //   // notifyListeners();
    // });
  }
  // SharedPreferences get prefs => _prefs;

  // getters to get the values
  bool get showHidden => _showHidden;
  void addPath(String path) {
    navigationAddOrRemove(data[currentPage].navItems, path);
    notifyListeners();
  }

  // to show and hide the navigation rail on opening new directory.

  // for setting the scroll listener.
  /// Only use this function for CircleChartAndFilePercent..
  String calculatePercent(int bytes, int decimals) {
    if (data.isEmpty) return '0.0';
    final _data = data[currentPage];
    final percent = bytes / ((_data.total - _data.free)) * 100;
    final result = percent.isNaN ? '0.0' : percent.toStringAsFixed(decimals);
    return result;
  }

  Future<void> createFileSystemEntity(String path, String name) async {
    final folderPath = p.join(path, name);
    try {
      notifyListeners();
      if (p.extension(folderPath) != '') {
        await File(folderPath).create();
      } else {
        await Directory(folderPath).create();
        // print(folderPath);
      }
      notifyListeners();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<FileSystemEntity>> dirContents(String path, {isShowHidden = false}) async {
    final args = {'path': path, 'showHidden': isShowHidden};
    try {
      final result = await FileUtils.worker.doWork(FileUtils.directoryList, args);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> diskSpace() async {
    spaceInfo = await StorageDetails.getspace;
    data = Data.storageToData(spaceInfo);
    notifyListeners();
  }

  Future<List<FileSystemEntity>> files() async {
    if (data.isEmpty) await diskSpace();
    return await Directory(data[currentPage].path).list().toList();
  }

  List<String> getListOfNavigation() {
    return data[currentPage]?.navItems;
  }

  Future<PermissionStatus> getPermission() async {
    try {
      final storage = Permission.storage;
      final statuses = await [Permission.storage].request();
      return statuses[storage];
    } catch (e) {
      print('permission error $e');
      rethrow;
    }
  }

  Future<void> init() async {
    final timer = Stopwatch()..start();
    await diskSpace();
    log('future completes in ${timer.elapsed.inMilliseconds}');
    timer.stop();
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

  void notify() => Future.delayed(Duration(milliseconds: 200), () => notifyListeners());

  Future<bool> onGoBack(context) async {
    final value = data[currentPage];
    if (value.currentPath == value.path) {
      Navigator.pop(context);
    } else {
      value.currentPath = Directory(value.currentPath).parent.path;
    }
    notifyListeners();
    return false;
  }

  void onPageChanged(int value) {
    currentPage = value;
    notifyListeners();
  }

  void ontap(FileSystemEntity dir) {
    if (dir is Directory) {
      data[currentPage].currentPath = dir.path;
      addPath(dir.path);
      scrollListener(6.0);
    } else {
      OpenFile.open(dir.path);
    }
    notifyListeners();
  }

  Future<void> rename(FileSystemEntity item, String name) async {
    final newPath = item.path.replaceAll(p.basename(item.path), name);
    await item.rename(newPath);
    notifyListeners();
  }

  void setScrollListener(Function listener) {
    scrollListener = listener;
  }

  void toggleHidden() {
    _showHidden = !_showHidden;
    notifyListeners();
  }
}
