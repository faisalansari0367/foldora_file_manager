
import 'package:files/pages/Videos/models/video_entity.dart';
import 'package:files/pages/Videos/models/video_file.dart';
import 'package:files/pages/Videos/models/video_folder.dart';
import 'package:files/utilities/Utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:storage_path/storage_path.dart';

class VideosProvider extends ChangeNotifier {
  int _videosSize = 0;
  List<VideoEntity> _selectedFiles = [];
  List<VideoFolder> _videosFolder = [];
  List<VideoFile> _videos = [];

  VideoFolder selectedVideoFolder;
  bool showInFolders = false;

  int get videosSize => _videosSize;
  List<VideoFolder> get videosFolder => _videosFolder;
  List<VideoFile> get videosFiles => _videos;

  VideosProvider() {
    videos();
  }

  void setShowInFolders(bool value) {
    showInFolders = value;
    notifyListeners();
  }

  Future<bool> onGoBack() async {
    if (selectedVideoFolder == null) {
      return true;
    } else {
      selectedVideoFolder = null;
      notifyListeners();
      return false;
    }
  }

  void onTap(VideoFolder videoModel) {
    selectedVideoFolder = videoModel;
    notifyListeners();
  }

  Future<void> videos() async {
    final videosPath = await StoragePath.videoPath;
    // log(videosPath);
    final List<VideoEntity> videos = await FileUtils.worker.doWork(videoFolderFromJson, videosPath);
    for (var item in videos) {
      if (item is VideoFolder) {
        videosFolder.add(item);
        videosFiles.addAll(item.files);
        _videosSize += item.size;
      }
    }

    // _videosFolder = videos['videoModel'];
    // _videosSize = videos['size'];
    // _videos = videos['videos'];
    print('_videosPath length :${_videosFolder.length}');
    notifyListeners();
  }

  // List<VideoFile> getVideos() {

  // }

  // void addFolders(VideoModel viderFolder) {}
  // void addFiles(Video video) {}

  void addOrRemoveVideos(VideoEntity entity) {
    final isExist = _selectedFiles.contains(entity);
    !isExist ? _selectedFiles.add(entity) : _selectedFiles.remove(entity);
    // final files = _selectedFiles;
    // _selectedFiles = files;
    print(_selectedFiles);
    notifyListeners();
  }
}
