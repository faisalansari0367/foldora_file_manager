import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:files/data_models/AudioModel.dart';
import 'package:files/data_models/DocumentsModel.dart';
import 'package:files/data_models/ImageModel.dart';
import 'package:files/data_models/VideoModel.dart';
import 'package:files/utilities/SearchUtils.dart';
import 'package:files/utilities/Worker.dart';
import 'package:path/path.dart' as p;
import 'package:video_thumbnail/video_thumbnail.dart';

// import 'package:flutter_image_compress/flutter_image_compress.dart';

class FileUtils {
  static Worker worker;
  FileUtils() {
    worker = Worker();
  }

  static const String apkIconPath = '/storage/emulated/0/.apkIcons';

  static String formatBytes(bytes, decimals, {bool inGB = false}) {
    if (bytes == 0 || bytes == -1) return '0 B';
    var k = 1024,
        dm = decimals <= 0 ? 0 : decimals,
        sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'],
        i = inGB ? 3 : (log(bytes) / log(k)).floor();
    return ((bytes / pow(k, i)).toStringAsFixed(dm)) + ' ' + sizes[i];
    // final size = "${bytes / pow(k,i)} ";
  }

  static Future<String> checkFileType(FileSystemEntity data) async {
    if (data is Directory) {
      var itemsCount = 'Directory';
      try {
        final List list = await data.list().toList();
        final length = list.length;
        itemsCount = length == 1 ? 'Directory | $length Item' : 'Directory | $length Items';
      } on FileSystemException catch (e) {
        print(e);
      }
      return itemsCount;
    } else {
      final size = data.statSync().size;
      return FileUtils.formatBytes(size, 2);
    }
  }

  static Map<String, dynamic> isVideoThumbnailExist(path) {
    final fileName = p.basenameWithoutExtension(path);
    final thumb = File('$apkIconPath/$fileName.png');

    final isFileExist = thumb.existsSync();
    final map = <String, dynamic>{};
    map['isFileExist'] = isFileExist;
    if (isFileExist) map['thumb'] = thumb;
    return map;
  }

  // ignore: missing_return
  static Future<String> createThumbnail(path) async {
    final apkIconDir = Directory(apkIconPath);
    if (!apkIconDir.existsSync()) await apkIconDir.create();
    final map = isVideoThumbnailExist(path);
    try {
      if (!map['isFileExist']) {
        final filePath = await VideoThumbnail.thumbnailFile(
          thumbnailPath: apkIconPath,
          video: path,
          imageFormat: ImageFormat.PNG,
          timeMs: 10000,
          quality: 100,
        );
        print('file is Located at: $filePath');
        return filePath;
      }
    } catch (e) {
      rethrow;
    }
  }

  static Map<String, dynamic> storagePathVideos(dynamic json) {
    final result = VideoModel.jsonToVideo(json);
    final videos = <Video>[];
    var size = 0;

    for (final item in result) {
      for (final i in item.videos) {
        videos.add(i);
        size += i.size;
      }
    }

    return {'videoModel': result, 'size': size, 'videos': videos};
  }

  /// this function works for StoragePath.audios, StoragePath.videos, StoragePath.files
  // static storagePathData(json) async {
  //   final decodedJson = parseFiles(json);
  //   List<Files> videos = [];
  //   int size = 0;
  //   for (var item in decodedJson) {
  //     for (var i in item.files) {
  //       videos.add(i);
  //       size += i.size != null ? i.size : 0;
  //     }
  //   }
  //   return {"data": decodedJson, "size": size, "videos": videos};
  // }

  static Map<String, dynamic> storagePathDocuments(json) {
    final decodedJson = jsonDecode(json);
    final result = DocumentsModel.jsonToDocument(decodedJson);
    var totalSize = 0;
    for (final i in result) {
      for (final e in i.document) {
        totalSize += e.size;
      }
    }
    return {'data': result, 'size': totalSize};
  }

  static Map<String, dynamic> storagePathAudios(json) {
    final audios = <Audio>[];
    var size = 0;
    final result = AudioModel.jsonToAudio(json);
    for (final item in result) {
      for (final i in item.audios) {
        audios.add(i);
        size += i?.size ?? 0;
      }
    }
    return {'data': result, 'size': size};
  }

  /// this function works for StoragePath.imagesPath
  static Future<Map<String, dynamic>> imagesPath(String json) async {
    final decodeJson = jsonDecode(json);
    var _size = 0;
    final storePhotos = <ImageModel>[];
    for (final item in decodeJson) {
      final model = ImageModel.fromJson(item);
      storePhotos.add(model);
      for (final i in item['files']) {
        final file = File(i);
        // storePhotos.add(file);
        final fileStat = await file.stat();
        _size += fileStat.size;
      }
    }
    return {'data': storePhotos, 'size': _size};
  }

  static List<FileSystemEntity> sortListAlphabetically(List<FileSystemEntity> list) {
    final sort =
        (a, b) => p.basename(a.path).toLowerCase().compareTo(p.basename(b.path).toLowerCase());
    list.sort(sort);
    return list;
  }

  ///This function returns all the apk files stored on the device.
  static Future<List<String>> getAllLocalApps() async {
    final args = {
      'path': '/storage/emulated/0',
      'query': '.apk',
      'wantOnlyPath': true,
      'withExt': true
    };
    final apksPaths = await worker.doWork(SearchUtils.doSearching, args);
    return apksPaths;
  }

  // ignore: missing_return
  static Future<List<FileSystemEntity>> directoryList(Map args) async {
    var sortedList = <FileSystemEntity>[];
    final directories = <Directory>[];
    final files = <File>[];
    final hiddenFiles = <FileSystemEntity>[];

    final String path = args['path'];
    final bool showHidden = args['showHidden'];

    try {
      final list = Directory(path).list();
      await for (final event in list) {
        if (p.basename(event.path).startsWith('.')) {
          hiddenFiles.add(event);
        } else {
          event is Directory ? directories.add(event) : files.add(event);
        }
      }

      sortListAlphabetically(directories);
      sortListAlphabetically(files);
      sortListAlphabetically(hiddenFiles);
      sortedList = sortedList += directories;
      sortedList = sortedList += files;
      if (showHidden) sortedList += hiddenFiles;
      return sortedList;
    } catch (e) {
      // print('error from directory LIst: $e');
      throw Exception(e);
    }
  }
}
