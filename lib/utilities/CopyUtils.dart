import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as p;

import 'Utils.dart';

class CopyUtils {
  static int _totalItemsSize = 0;
  static int _copied = 0;
  static double _progress = 0.0;

  static void clearFields() {
    _totalItemsSize = 0;
    _copied = 0;
    _progress = 0.0;
  }

  static void simpleCopy(Map args) async {
    // Map args = {'items': selectedMedia[0], 'currentPath': MediaUtils.currentPath};
    File file = args['items'];
    String dest = args['currentPath'];
    print('copyStated');
    var timer = Stopwatch()..start();
    await file.copy(p.join(dest, p.basename(file.path)));
    print('copy done ${timer.elapsed.inSeconds}');
  }

  static Stream<Map<String, dynamic>> copySelectedItems(Map map) async* {
    final List<FileSystemEntity> items = map['items'];
    final String path = map['currentPath'];
    _totalItemsSize = await _getTotalSize(items);
    for (var item in items) {
      if (item is File) {
        yield* _copyFileSystemEntity(item, path);
      } else if (item is Directory) {
        yield* _toCopyDirectories(item, path);
      }
    }
    clearFields();
  }

  static Stream<Map<String, dynamic>> _toCopyDirectories(
    Directory item,
    String currentPath,
  ) async* {
    final copiedDir = Directory(p.join(currentPath, p.basename(item.path)));
    await copiedDir.create();
    var stream = item.list();
    await for (var file in stream) {
      if (file is Directory) {
        yield* _toCopyDirectories(file, copiedDir.path);
      } else if (file is File) {
        yield* _copyFileSystemEntity(file, copiedDir.path);
      }
    }
  }

  static Stream<Map<String, dynamic>> _copyFileSystemEntity(
    File file,
    String folderDestPath,
  ) async* {
    final Stream<List<int>> srcFile = file.openRead();
    final int srcFileLength = await file.length();
    var _srcSize = FileUtils.formatBytes(srcFileLength, 2);
    var _srcName = p.basename(file.path);
    final String destPath = p.join(folderDestPath, p.basename(file.path));
    var destFile = File(destPath).openWrite(mode: FileMode.append);
    await for (var event in srcFile) {
      destFile.add(event);
      _copied += event.length;
      _progress = _copied / _totalItemsSize * 100;
      yield {
        'copied': _copied,
        'progress': _progress,
        'srcName': _srcName,
        'srcSize': _srcSize,
      };
    }
    await destFile.close();
  }

  static Future<int> _getTotalSize(List<FileSystemEntity> _selectedMediaItems) async {
    var totalSize = 0;
    for (var item in _selectedMediaItems) {
      if (item is Directory) {
        totalSize += await _getDirectorySize(item);
      } else if (item is File) {
        final FileStat stat = await item.stat();
        totalSize += stat.size;
      }
    }
    return totalSize;
  }

  static Future<int> _getDirectorySize(Directory item) async {
    var totalSize = 0;
    await for (var dir in item.list()) {
      if (dir is Directory) {
        totalSize += await _getDirectorySize(dir);
      } else if (dir is File) {
        final FileStat stat = await dir.stat();
        totalSize += stat.size;
      }
    }
    return totalSize;
  }
}
