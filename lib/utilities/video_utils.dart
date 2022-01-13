import 'dart:developer';
import 'dart:io';

import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path/path.dart' as p;

class VideoUtil {
  static const String thumbnailDir = '/storage/emulated/0/.thumbnails';
  static Map<String, dynamic> isVideoThumbnailExist(path) {
    final fileName = p.basenameWithoutExtension(path);
    final thumb = File('$thumbnailDir/$fileName.png');
    final isFileExist = thumb.existsSync();
    final map = <String, dynamic>{};
    map['isFileExist'] = isFileExist;
    if (isFileExist) map['thumb'] = thumb;
    return map;
  }

  // ignore: missing_return
  static Future<File> createThumbnail(path) async {
    final apkIconDir = Directory(thumbnailDir);
    if (!apkIconDir.existsSync()) await apkIconDir.create();
    final map = isVideoThumbnailExist(path);
    
    try {
      if (!map['isFileExist']) {
        final filePath = await VideoThumbnail.thumbnailFile(
          thumbnailPath: thumbnailDir,
          video: path,
          imageFormat: ImageFormat.PNG,
          timeMs: 10000,
          quality: 100,
        );
        print('file is Located at: $filePath');
        return File(filePath);
      }
      return map['thumb'];
    } catch (e) {
      log(e.toString());
    }
  }
}
