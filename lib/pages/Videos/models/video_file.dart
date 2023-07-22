import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:files/pages/Videos/models/video_entity.dart';

VideoFile videoFileFromJson(String str) => VideoFile.fromJson(json.decode(str));

String videoFileToJson(VideoFile data) => json.encode(data.toJson());

class VideoFile implements VideoEntity {
  VideoFile({
    this.album,
    this.artist,
    this.file,
    this.dateAdded,
    this.displayName,
    this.duration,
    this.thumbnail,
    this.resolution,
    this.size,
    this.folderName,
  });

  String? album;
  String? artist;
  File? file;
  String? dateAdded;
  String? displayName;
  String? duration;
  String? resolution;
  String? folderName;
  // int size;
  Uint8List? thumbnail;

  factory VideoFile.fromJson(Map<String, dynamic> json) => VideoFile(
        album: json['album'],
        artist: json['artist'],
        file: File(json['path']),
        dateAdded: json['dateAdded'],
        displayName: json['displayName'],
        duration: json['duration'],
        resolution: json['resolution'],
        thumbnail: json['thumbnail'],
      );

  factory VideoFile.fromMap(Map<Object, Object> json) => VideoFile(
        album: json['album'] as String?,
        artist: json['artist'] as String?,
        file: File(json['imagePath'] as String),
        dateAdded: json['date'] as String?,
        displayName: json['name'] as String?,
        duration: json['duration'] as String?,
        resolution: json['resolution'] as String?,
        thumbnail: json['thumbnail'] as Uint8List?,
        folderName: json['folderName'] as String?,
        size: int.parse(json['size'] as String),
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

  // @override
  // int get size => file.statSync().size;

  @override
  void delete() {
    file!.delete();
  }

  @override
  int? size;
}
