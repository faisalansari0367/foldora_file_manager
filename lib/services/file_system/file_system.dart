import 'dart:io';

import 'package:path/path.dart' as p;

class FileSystem {
  static Future<void> createDir(String path, String name) async {
    final folderPath = p.join(path, name);
    final dir = Directory(folderPath);
    if (await dir.exists()) return;
    await dir.create();
  }

  static Future<void> createFile(String path, String name) async {
    final folderPath = p.join(path, name);
    final dir = File(folderPath);
    if (await dir.exists()) return;
    await dir.create();
  }
}
