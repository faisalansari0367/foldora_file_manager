import 'dart:convert';

import 'package:files/pages/Videos/models/video_entity.dart';
import 'package:files/pages/Videos/models/video_file.dart';

List<VideoEntity> videoFolderFromJson(String str) {
  return (jsonDecode(str) as List).map((e) {
    return VideoFolder.fromJson(e);
  }).toList();
}

class VideoFolder extends VideoEntity {
  final List<VideoFile> files;
  final String folderName;

  VideoFolder({this.files, this.folderName});

  static List<VideoFile> getFiles(List data) {
    return List.generate(data.length, (index) => VideoFile.fromJson(data[index]));
  }

  factory VideoFolder.fromJson(Map<String, dynamic> json) {
    return VideoFolder(
      files: getFiles(json['files']),
      folderName: json['folderName'],
    );
  }

  @override
  int get size {
    var size = 0;
    files.forEach((element) => size += element.size);
    return size;
  }
}
