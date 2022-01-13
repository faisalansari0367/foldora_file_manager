import 'dart:convert';
import 'dart:io';

import 'package:files/pages/Videos/models/video_entity.dart';

VideoFile videoFileFromJson(String str) => VideoFile.fromJson(json.decode(str));

String videoFileToJson(VideoFile data) => json.encode(data.toJson());

class VideoFile extends VideoEntity {
  VideoFile({
    this.album,
    this.artist,
    this.file,
    this.dateAdded,
    this.displayName,
    this.duration,
    // this.size,
  });

  String album;
  String artist;
  File file;
  String dateAdded;
  String displayName;
  String duration;
  // String size;

  factory VideoFile.fromJson(Map<String, dynamic> json) => VideoFile(
        album: json['album'],
        artist: json['artist'],
        file: File(json['path']),
        dateAdded: json['dateAdded'],
        displayName: json['displayName'],
        duration: json['duration'],
        // size: json['size'],
      );

  Map<String, dynamic> toJson() => {
        'album': album,
        'artist': artist,
        'path': file,
        'dateAdded': dateAdded,
        'displayName': displayName,
        'duration': duration,
        // 'size': size,
      };

  @override
  int get size => file.statSync().size;
}
