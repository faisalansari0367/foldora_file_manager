// import 'dart:convert';
// import 'dart:io';

// class FileModel {
//   String folderName;
//   List<Files> files;

//   FileModel({this.files, this.folderName});

//   factory FileModel.fromJson(Map<String, dynamic> json) {
//     return FileModel(
//       files: filesToListOfFiles(
//           json["files"].map((e) => Files.fromJson(e)).toList()),
//       folderName: json['folderName'],
//     );
//   }

//   static List<Files> filesToListOfFiles(files) {
//     List<Files> listFiles = List<Files>.from(files);
//     return listFiles;
//   }
// }

// enum STORAGE { IMAGES, VIDEOS, AUDIOS, DOCUMENTS }

// class Files {
//   String album;
//   String artist;
//   File file;
//   String dateAdded;
//   String displayName;
//   String duration;
//   int size;
//   // String thumbnail;

//   Files({
//     this.album,
//     this.artist,
//     this.file,
//     this.dateAdded,
//     this.displayName,
//     this.duration,
//     this.size,
//     // this.thumbnail,
//   });

//   static checkForNull(dynamic value) => value != null ? value : null;

//   factory Files.fromJson(Map<String, dynamic> json) {
//     return Files(
//       album: checkForNull(json['album']),
//       artist: checkForNull(json['artist']),
//       file: json['path'] != null ? File(json['path']) : null,
//       dateAdded: checkForNull(json['dateAdded']),
//       displayName: checkForNull(json['displayName']),
//       duration: checkForNull(json['duration']),
//       size: int.parse(checkForNull(json['size'])),
//     );
//   }
// }

// List<FileModel> parseFiles(path) {
//   final parsed = jsonDecode(path).cast<Map<String, dynamic>>();
//   try {
//     return parsed.map<FileModel>((json) => FileModel.fromJson(json)).toList();
//   } catch (e) {
//     throw Exception(e);
//   }
// }

// class DocumentsModel {
//   final String folderName;
//   final List<Document> document;

//   DocumentsModel({this.folderName, this.document});

//   static List<DocumentsModel> jsonToDocument(List json) {
//     return List.generate(json.length, (index) {
//       final data = json[index];
//       return DocumentsModel(
//         document: _listOfDocument(data['files']),
//         folderName: data['folderName'],
//       );
//     });
//   }

//   static _listOfDocument(List files) {
//     return List.generate(files.length, (index) {
//       final document = files[index];
//       return Document(
//         file: File(document['path']),
//         mimeType: document['mimeType'],
//         size: int.parse(document['size']),
//         title: document['title'],
//       );
//     });
//   }

//   static videoFiles(decodedJson) {
//     return List.generate(decodedJson.length, (index) {
//       final files = decodedJson[index];
//       return Files(
//         file: files['path'],
//         dateAdded: files['dateAdded'],
//         displayName: files['dateAdded'],
//         size: files['size'],
//         duration: files['duration'],
//       );
//     });
//   }
// }

// class Document {
//   final String mimeType;
//   final int size;
//   final String title;
//   final File file;
//   Document({this.mimeType, this.size, this.title, this.file});
// }

// class VideoModel {
//   final String folderName;
//   final List<Video> videos;

//   VideoModel({this.folderName, this.videos});

//   static _videoFiles(decodedJson) {
//     return List.generate(decodedJson.length, (index) {
//       final files = decodedJson[index];
//       return Files(
//         file: files['path'],
//         dateAdded: files['dateAdded'],
//         displayName: files['dateAdded'],
//         size: files['size'],
//         duration: files['duration'],
//       );
//     });
//   }

//   static List<VideoModel> jsonToVideo(json) {
//     final source = jsonDecode(json);
//     return List.generate(source.length, (index) {
//       final value = source[index];
//       return VideoModel(
//         videos: _videoFiles(value['files']),
//         folderName: value['folderName'],
//       );
//     });
//   }
// }

// class Video {
//   final File file;
//   final String dateAdded;
//   final String displayName;
//   final int size;
//   final String duration;

//   Video({
//     this.file,
//     this.dateAdded,
//     this.displayName,
//     this.size,
//     this.duration,
//   });
// }

// class AudioModel {
//   final String folderName;
//   final List<Audio> audios;
//   AudioModel({this.folderName, this.audios});

//   static audioFiles(decodedJson) {
//     return List.generate(decodedJson.length, (index) {
//       final files = decodedJson[index];
//       return Audio(
//         artist: files['artist'],
//         album: files['album'],
//         file: File(files['path']),
//         dateAdded: files['dateAdded'],
//         displayName: files['dateAdded'],
//         size: int.parse(files['size']),
//         duration: files['duration'],
//       );
//     });
//   }

//   static List<AudioModel> jsonToAudio(json) {
//     final source = jsonDecode(json);
//     return List.generate(source.length, (index) {
//       final data = source[index];
//       return AudioModel(
//         audios: audioFiles(data['files']),
//         folderName: data["folderName"],
//       );
//     });
//   }
// }

// class Audio {
//   final String album;
//   final String artist;
//   final File file;
//   final String dateAdded;
//   final String displayName;
//   final int duration;
//   final int size;

//   Audio({
//     this.album,
//     this.artist,
//     this.file,
//     this.dateAdded,
//     this.displayName,
//     this.duration,
//     this.size,
//   });
// }
