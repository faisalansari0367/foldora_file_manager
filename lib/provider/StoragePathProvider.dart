import 'package:files/data_models/VideoModel.dart';
import 'package:files/utilities/Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:storage_path/storage_path.dart';

class StoragePathProvider extends ChangeNotifier {
  StoragePathProvider() {
    getPermission();
    // onRefresh();
  }

  Future<void> getPermission() async {
    if (await Permission.storage.isGranted) {
      onRefresh();
    }
  }

  int _documentsSize = 0;
  int _audiosSize = 0;
  int _videosSize = 0;
  int _photosSize = 0;
  int photosIndex = 0;

  int get documentsSize => _documentsSize;
  int get audiosSize => _audiosSize;
  int get videosSize => _videosSize;
  int get photosSize => _photosSize;
  int get mediaSize => _audiosSize + _videosSize ?? 0;

  List<VideoModel> _videosPath = [];
  List<VideoModel> get videosPath => _videosPath;

  List<Video> _videos = [];
  List<Video> get videosFiles => _videos;

  List _audiosPath = [];
  List _documentsPath = [];
  List _rootDirectories = [];
  List _photos = [];
  List get imagesPath => _photos;
  List get rootDirectory => _rootDirectories;
  List get audiosPath => _audiosPath;
  List get documentsPath => _documentsPath;

  void updateIndex(index) {
    photosIndex = index;
    notifyListeners();
  }

  bool reverse = false;
  void onHorizontalDragEnd(double velocity, int value) {
    if (velocity < 0 && velocity != 0.0) {
      reverse = false;
      if (value != imagesPath.length - 1) updateIndex(value + 1);
      // updateIndex(value + 1);
    } else if (velocity > 0 && velocity != 0.0) {
      reverse = true;
      if (value != 0) updateIndex(value - 1);
    }
  }

  Future<void> photos() async {
    final imagesPath = await StoragePath.imagesPath;
    print(imagesPath);
    final images =
        await FileUtils.worker.doWork(FileUtils.imagesPath, imagesPath);
    // await FileUtils.imagesPath(imagesPath);
    _photos = images['data'];
    _photosSize = images['size'];
    notifyListeners();
  }

  Future<void> documents() async {
    final documents = await StoragePath.filePath;
    final docs = await FileUtils.worker
        .doWork(FileUtils.storagePathDocuments, documents);
    // final docs = await FileUtils.storagePathDocuments(documents);
    _documentsPath = docs['data'];
    _documentsSize = docs['size'];
    notifyListeners();
  }

  Future<void> videos() async {
    await Permission.storage.status;
    final videosPath = await StoragePath.videoPath;
    print(videosPath);
    final videos =
        await FileUtils.worker.doWork(FileUtils.storagePathVideos, videosPath);
    // await FileUtils.storagePathVideos(videosPath);
    _videosPath = videos['videoModel'];
    _videosSize = videos['size'];
    _videos = videos['videos'];
    notifyListeners();
    // for (var item in _videosPath) {
    //   for (var i in item.files) {
    //     await FileUtils.createThumbnail(i.file.path);
    //   }
    // }
    // notifyListeners();
  }

  Future<void> audios() async {
    final audiosPath = await StoragePath.audioPath;
    print(audiosPath);
    final audios =
        await FileUtils.worker.doWork(FileUtils.storagePathAudios, audiosPath);
    // await FileUtils.storagePathAudios(audiosPath);
    _audiosPath = audios['data'];
    _audiosSize = audios['size'];
    notifyListeners();
  }

  Future<void> onRefresh() async {
    photos();
    videos();
    audios();
    documents();
    await Future.delayed(Duration(seconds: 1));
  }
}
