import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:files/utilities/CopyUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart' as p;
import '../utilities/OperationsUtils.dart';

class OperationsProvider extends ChangeNotifier {
  int _copied = 0;
  double _progress = 0.0;
  String _speed = '';
  String _remaining = '';
  String _srcName = '';
  String _srcSize = '0.0 KB';
  int selectedIndex = 5;
  bool showCopy = true;
  List<FileSystemEntity> _selectedMediaItems = [];

  String get totalSize => _srcSize;
  String get speed => _speed;
  int get copied => _copied;
  String get remaining => _remaining;
  String get srcName => _srcName;
  double get progress => _progress;
  List<FileSystemEntity> get selectedMedia => _selectedMediaItems;

  // for sharing the files
  List<String> sharePaths() {
    final paths = _selectedMediaItems.map((e) => e.path).toList();
    return paths;
  }

  void ontapCopy() {
    showCopy = !showCopy;
    // showBottomNavbar = !showBottomNavbar;
    notifyListeners();
  }

  /// have to deal with it. it should not be in here.
  bool showBottomNavbar = false;

  void onTapOfLeading(FileSystemEntity item) {
    final isExist = _selectedMediaItems.contains(item);
    isExist ? _selectedMediaItems.remove(item) : _selectedMediaItems.add(item);
    // operations.selectItem(_selectedMediaItems, item);
    showBottomNavbar = _selectedMediaItems.isEmpty ? false : true;
    print(_selectedMediaItems);
    notifyListeners();
  }

  Future<void> deleteFileOrFolder() async {
    if (_selectedMediaItems.isEmpty) return;
    try {
      for (final item in _selectedMediaItems) {
        final result = await item.delete(recursive: true);
        print('item deleted $result');
      }
      _selectedMediaItems.clear();
      notifyListeners();
    } on FileSystemException catch (e) {
      print('item deletion failed : $e');
    }
    notifyListeners();
  }

  bool operationIsRunning = false;

  Future<void> copySelectedItems(String currentPath) async {
    if (selectedMedia.isEmpty) return;
    operationIsRunning = true;

    final Map args = {'items': selectedMedia, 'currentPath': currentPath};
    final Stream<dynamic> stream = CopyUtils.copySelectedItems(args);
    // await FileUtils.worker.doOperation(CopyUtils.copySelectedItems, args);

    stream.listen((event) {
      if (event is String) {
        operationIsRunning = false;
        clearFields();
        return;
      }
      _copied = event['copied'];
      _progress = event['progress'];
      _srcName = event['srcName'];
      _srcSize = event['srcSize'];
      notifyListeners();
    });
  }

  Future<void> move(String currentPath) async {
    operationIsRunning = true;
    final totalFiles = _selectedMediaItems.length;
    int movedFiles = 0;
    // final currentPath = MediaUtils.currentPath;
    for (final item in _selectedMediaItems) {
      movedFiles++;
      _srcName = p.basename(item.path);
      try {
        await item.rename(p.join(currentPath, _srcName));
      } catch (e) {
        log('item moving failed $e');
      }
      _progress = movedFiles / totalFiles * 100;
    }
    operationIsRunning = false;
    clearFields();
    // notifyListeners();
  }

  Future<void> renameFSE(BuildContext context) async {
    for (final item in _selectedMediaItems) {
      await OperationsUtils.myDialog(
        context,
        item: item,
        eventName: 'rename',
      );
    }
    notifyListeners();
  }

  void clearFields() {
    _progress = 0.0;
    _speed = '';
    _copied = 0;
    _remaining = '';
    _srcName = '';
    _srcSize = '0.0 KB';
    _selectedMediaItems.clear();
    notifyListeners();
  }

  // _speedPerSecond(bytes) {
  //   var bytes = 0;
  //   var perSecondSpeed = 0;
  //   Timer timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
  //     _speed = FileUtils.formatBytes(bytes - perSecondSpeed, 2);
  //     perSecondSpeed = bytes;
  //   });
  //   timer.cancel();
  // }
}
