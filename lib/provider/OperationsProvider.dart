import 'dart:async';
import 'dart:io';

import 'package:files/utilities/CopyUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart' as p;
import '../sizeConfig.dart';
import '../utilities/OperationsUtils.dart';

class Operations extends ChangeNotifier {
  int _copied = 0;
  double _progress = 0.0;
  String _speed = '';
  String _remaining = '';
  String _srcName = '';
  String _srcSize = '0.0 KB';
  List<FileSystemEntity> _selectedMediaItems = [];

  String get totalSize => _srcSize;
  String get speed => _speed;
  int get copied => _copied;
  String get remaining => _remaining;
  String get srcName => _srcName;
  double get progress => _progress;
  List<FileSystemEntity> get selectedMedia => _selectedMediaItems;

  // this is not related to operations its for appbar
  double appbarSize = 0 * Responsive.heightMultiplier;
  bool navRail = false;
  void scrollListener(double size) {
    appbarSize = size * Responsive.heightMultiplier;
    // navRail = navigation;
    notifyListeners();
  }

  double scrolledPixels = 0.0;
  void pixelsScrolled(double value) {
    scrolledPixels = value;
    notifyListeners();
  }

  //
  List<String> sharePaths() {
    var paths = _selectedMediaItems.map((e) => e.path).toList();
    return paths;
  }

  int selectedIndex = 5;
  bool showCopy = true;

  void ontapCopy() {
    showCopy = !showCopy;
    // showBottomNavbar = !showBottomNavbar;
    notifyListeners();
  }

  bool showBottomNavbar = false;

  void onTapOfLeading(FileSystemEntity item) {
    var isExist = _selectedMediaItems.contains(item);
    isExist ? _selectedMediaItems.remove(item) : _selectedMediaItems.add(item);
    showBottomNavbar = _selectedMediaItems.isEmpty ? false : true;
    print(_selectedMediaItems);
    notifyListeners();
  }

  Future<void> deleteFileOrFolder() async {
    if (_selectedMediaItems.isEmpty) return;
    try {
      for (var item in _selectedMediaItems) {
        await item.delete(recursive: true);
      }
      _selectedMediaItems.clear();
    } on FileSystemException catch (e) {
      print(e.toString());
      // StorageDetails.deleteWhenError(sharePaths());
      // notifyListeners();
    }
    notifyListeners();
  }

  bool operationIsRunning = false;

  Future<void> copySelectedItems(String currentPath) async {
    operationIsRunning = true;
    Map args = {'items': selectedMedia, 'currentPath': currentPath};
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
    for (var item in _selectedMediaItems) {
      movedFiles++;
      _srcName = p.basename(item.path);
      await item.rename(p.join(currentPath, _srcName));
      _progress = movedFiles / totalFiles * 100;
    }
    operationIsRunning = false;
    clearFields();
    notifyListeners();
  }

  Future<void> renameFSE(BuildContext context) async {
    for (var item in _selectedMediaItems) {
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
