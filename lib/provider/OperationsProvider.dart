import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:files/utilities/CopyUtils.dart';
import 'package:files/utilities/operations_isolate.dart';
import 'package:files/utilities/storage_space.dart';
import 'package:flutter/material.dart';
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
  final _selectedMediaItems = <FileSystemEntity>[];
  bool operationIsRunning = false;

  String get totalSize => _srcSize;
  String get speed => _speed;
  int get copied => _copied;
  String get remaining => _remaining;
  String get srcName => _srcName;
  double get progress => _progress;
  List<FileSystemEntity> get selectedMedia => _selectedMediaItems;
  int selectedItemSizeBytes = 0;

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

  void selectAll(List<FileSystemEntity> list) {
    _selectedMediaItems.clear();
    // final selected = _selectedMediaItems.removeWhere((element) => list.contains(element));
    _selectedMediaItems.addAll(list);
    notifyListeners();
  }

  void selectInverse(List<FileSystemEntity> list) {
    final mylist = [..._selectedMediaItems];
    _selectedMediaItems.clear();
    list.forEach((e) {
      if (mylist.any((element) => element.path == e.path)) {
        _selectedMediaItems.remove(e);
      } else {
        _selectedMediaItems.add(e);
      }
    });
    notifyListeners();
  }

  void onTapOfLeading(FileSystemEntity item) {
    final isExist = _selectedMediaItems.contains(item);
    if (isExist) {
      _selectedMediaItems.remove(item);
      removeSelectedItemSize(item);
    } else {
      _selectedMediaItems.add(item);
      addSelectedItemSize(item);
    }
    // operations.selectItem(_selectedMediaItems, item);
    showBottomNavbar = _selectedMediaItems.isEmpty ? false : true;
    notifyListeners();
  }

  void addSelectedItemSize(FileSystemEntity item) async {
    final stat = await item.stat();
    selectedItemSizeBytes += stat.size;
  }

  void removeSelectedItemSize(FileSystemEntity item) async {
    final stat = await item.stat();
    selectedItemSizeBytes -= stat.size;
  }

  Future<void> deleteFileOrFolder(BuildContext context) async {
    if (_selectedMediaItems.isEmpty) return;
    try {
      for (final item in _selectedMediaItems) {
        final result = await item.delete(recursive: true);
        print('item deleted $result');
      }
      _selectedMediaItems.clear();
    } on FileSystemException catch (e) {
      print('item deletion failed : $e');
      final snackBar = SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Text(e.toString()),
      );
      ScaffoldMessenger.maybeOf(context).showSnackBar(snackBar);
      // _selectedMediaItems.clear();
      final paths = sharePaths();
      final result = await StorageSpace.deleteWhenError(paths);
      final _snackBar = SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Text(result.toString()),
      );
      ScaffoldMessenger.maybeOf(context).showSnackBar(_snackBar);
      // notifyListeners();
    }
    notifyListeners();
  }

  Map<String, String> getFiles(List<FileSystemEntity> list) {
    var files = 0;
    var folders = 0;
    for (var item in list) {
      if (item is File) {
        files++;
      } else {
        folders++;
      }
    }
    return {
      'files': files.toString(),
      'folders': folders.toString(),
    };
  }

  Future<void> copySelectedItems(String currentPath, void Function() notify) async {
    if (selectedMedia.isEmpty) return;
    operationIsRunning = true;
    notifyListeners();

    // final args = {'items': selectedMedia, 'currentPath': currentPath};
    final isolate = OperationIsolate();
    final util = IsolateCopyProgress(
      filesToCopy: selectedMedia,
      pathWhereToCopy: currentPath,
    );

    // final stream = await isolate.operationsIsolate(
    //   filesToCopy: selectedMedia,
    //   pathWhereToCopy: currentPath,
    // );
    // final Stream<dynamic> stream = CopyUtils.copySelectedItems(args);
    final stream = util.copySelectedItems();

    // await FileUtils.worker.doOperation(CopyUtils.copySelectedItems, args);

    stream.listen((event) {
      // print(event);
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
    }, onDone: () {
      print('stream done');
      operationIsRunning = false;
      clearFields();
      notify();
      isolate.isolate.kill();
    });
  }

  void removeItem(FileSystemEntity item) {
    selectedMedia.contains(item) ? selectedMedia.remove(item) : null;
    notifyListeners();
  }

  Future<void> move(String currentPath) async {
    operationIsRunning = true;
    final totalFiles = _selectedMediaItems.length;
    var movedFiles = 0;
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
