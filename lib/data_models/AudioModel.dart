import 'dart:convert';
import 'dart:io';

class AudioModel {
  final String folderName;
  final List<Audio> audios;
  AudioModel({this.folderName, this.audios});

  static List<Audio> audioFiles(decodedJson) {
    final list = List.generate(decodedJson.length, (index) {
      final files = decodedJson[index];
      // print(files);q
      try {
        return Audio(
          artist: files['artist'],
          album: files['album'],
          file: File(files['path']),
          dateAdded: files['dateAdded'],
          displayName: files['displayName'],
          size: int.parse(files['size']),
          duration: files['duration'],
        );
      } catch (e) {
        print('error: $e');
      }
    });
    return list;
  }

  static List<AudioModel> jsonToAudio(json) {
    final source = jsonDecode(json);
    return List.generate(source.length, (index) {
      final data = source[index];
      return AudioModel(
        audios: audioFiles(data['files']),
        folderName: data["folderName"],
      );
    });
  }
}

class Audio {
  final String album;
  final String artist;
  final File file;
  final String dateAdded;
  final String displayName;
  final String duration;
  final int size;

  Audio({
    this.album,
    this.artist,
    this.file,
    this.dateAdded,
    this.displayName,
    this.duration,
    this.size,
  });
}
