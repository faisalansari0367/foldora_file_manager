import 'dart:convert';
import 'dart:io';

class VideoModel {
  final String folderName;
  final int totalSize;
  final List<Video> videos;

  VideoModel({this.totalSize, this.folderName, this.videos});

  static List<Video> _videoFiles(decodedJson) {
    return List.generate(decodedJson.length, (index) {
      final files = decodedJson[index];
      // final size = ;
      return Video(
        file: File(files['path']),
        dateAdded: files['dateAdded'],
        displayName: files['displayName'],
        size: int.parse(files['size']),
        duration: files['duration'],
      );
    });
  }

  static int _getTotalSize(List<Video> videos) {
    var size = 0;
    for (var item in videos) {
      size += item.size;
    }
    return size;
  }

  static List<VideoModel> jsonToVideo(json) {
    final source = jsonDecode(json);
    return List.generate(source.length, (index) {
      final value = source[index];
      final videos = _videoFiles(value['files']);
      return VideoModel(
        videos: videos,
        folderName: value['folderName'],
        totalSize: _getTotalSize(videos),
      );
    });
  }
}

class Video {
  final File file;
  final String dateAdded;
  final String displayName;
  final int size;
  final String duration;

  Video({
    this.file,
    this.dateAdded,
    this.displayName,
    this.size,
    this.duration,
  });
}
