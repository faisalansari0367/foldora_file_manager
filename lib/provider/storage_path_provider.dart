import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:files/data_models/ImageModel.dart';
import 'package:flutter/material.dart';
// import 'package:storage_path/storage_path.dart';

class StoragePathProvider extends ChangeNotifier {
  final int _documentsSize = 0;
  final int _audiosSize = 0;
  int _videosSize = 0;
  final int _photosSize = 0;
  int? photosIndex = 0;
  int pageViewCurrentIndex = 0;
  bool hasBottomNav = false;

  int get documentsSize => _documentsSize;
  int get audiosSize => _audiosSize;
  int get videosSize => _videosSize;
  int get photosSize => _photosSize;
  int get mediaSize => _audiosSize + _videosSize;

  // List<VideoModel> _videosPath = [];
  // List<VideoModel> get videosPath => _videosPath;

  // List<Video> _videos = [];
  // List<Video> get videosFiles => _videos;
  List<int?> selectedPhotos = [];
  final List _audiosPath = [];
  final List _documentsPath = [];
  // final List _rootDirectories = [];
  final List<ImageModel> _photos = [];
  List<ImageModel> get imagesPath => _photos;
  // List get rootDirectory => _rootDirectories;
  List get audiosPath => _audiosPath;
  List get documentsPath => _documentsPath;

  var allPhotos = <File>[];

  StoragePathProvider() {
    init();
    // watching();
    // _imagesObserver();
  }

  void setVideosSize(int size) => {
        _videosSize = size,
        notifyListeners(),
      };

  ///  these functions are used by photos they are not getting used here
  void updateIndex(int? index) {
    photosIndex = index;
    // notifyListeners();
  }

  /// this function updates the index to delete the photo in pageView
  void updatePageViewCurrentIndex(int index) {
    pageViewCurrentIndex = index;
    notifyListeners();
  }

  final duration = const Duration(milliseconds: 200);

  void deleteAndUpdateImage(PageController controller) {
    log('index is $pageViewCurrentIndex');
    controller.animateToPage(
      pageViewCurrentIndex + 1,
      duration: duration,
      curve: Curves.fastOutSlowIn,
    );
    deletePhoto(pageViewCurrentIndex);
    updatePageViewCurrentIndex(pageViewCurrentIndex + 1);
    log('after updating index $pageViewCurrentIndex');
  }

  void addImage(int? index) {
    final exist = selectedPhotos.contains(index);
    exist ? selectedPhotos.remove(index) : selectedPhotos.add(index);
    notifyListeners();
  }

  Future<void> deletePhotos(List<FileSystemEntity> list) async {
    for (final item in list) {
      await item.delete();
    }
    notifyListeners();
  }

  bool reverse = false;
  void onHorizontalDragEnd(double velocity, int value) {
    if (velocity < 0 && velocity != 0.0) {
      reverse = false;
      if (value != imagesPath.length - 1) {
        updateIndex(value + 1);
      }
    } else if (velocity > 0 && velocity != 0.0) {
      reverse = true;
      if (value != 0) {
        updateIndex(value - 1);
      }
    }
  }

  /// end

  Future<void> photos() async {
    try {
      // // final imagesPath = await StoragePath.imagesPath;
      // // log(imagesPath);
      // final images = await FileUtils.worker.doWork(FileUtils.imagesPath, imagesPath);
      // // await FileUtils.imagesPath(imagesPath);
      // _photos = images['data'];
      // for (var item in _photos) {
      //   for (var i in item.files) {
      //     allPhotos.add(File(i));
      //   }
      // }
      // _photosSize = images['size'];

      print('images length :${_photos.length}');
      notifyListeners();
    } on Exception catch (e) {
      log('error from storage path images ${e.toString()}');
    }
  }

  /// for deleting photos
  void deletePhoto(int index) async {
    // await _photos[index].delete();
    _photos.removeAt(index);
    notifyListeners();
  }

  /// on long press in photos
  void onLongPress(int? index) {
    selectedPhotos.contains(index) ? selectedPhotos.remove(index) : selectedPhotos.add(index);
    hasBottomNav = selectedPhotos.isEmpty ? false : true;
    notifyListeners();
  }

  Future<void> documents() async {
    // final documents = await StoragePath.filePath;
    // final docs = await FileUtils.worker.doWork(FileUtils.storagePathDocuments, documents);
    // // final docs = await FileUtils.storagePathDocuments(documents);
    // _documentsPath = docs['data'];
    // _documentsSize = docs['size'];
    // print('_documentsPath length :${_documentsPath.length}');
    notifyListeners();
  }

  // Future<void> videos() async {
  //   await Permission.storage.status;
  //   final videosPath = await StoragePath.videoPath;
  //   final videos = await FileUtils.worker.doWork(FileUtils.storagePathVideos, videosPath);
  //   // await FileUtils.storagePathVideos(videosPath);
  //   _videosPath = videos['videoModel'];

  //   _videosSize = videos['size'];
  //   _videos = videos['videos'];
  //   print('_videosPath length :${_videosPath.length}');
  //   notifyListeners();
  // }

  Future<void> audios() async {
    // final audiosPath = await StoragePath.audioPath;
    // final audios = await FileUtils.worker.doWork(FileUtils.storagePathAudios, audiosPath);
    // // await FileUtils.storagePathAudios(audiosPath);
    // _audiosPath = audios['data'] as List<AudioModel>;
    // _audiosSize = audios['size'];
    // if (_audiosPath.isNotEmpty) print('_audiosPath length :${_audiosPath[0].audios.length}');

    notifyListeners();
  }

  Future<void> init() async {
    final timer = Stopwatch()..start();
    await Future.wait([photos(), audios(), documents()]);
    log('future completes in ${timer.elapsed.inMilliseconds} ms');
    timer.stop();
  }

  Future<void> onRefresh() async {
    await init();
    await Future.delayed(Duration(seconds: 2));
  }
}
