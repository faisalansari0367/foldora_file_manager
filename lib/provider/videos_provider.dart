import 'package:files/data_models/VideoModel.dart';
import 'package:files/utilities/Utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:storage_path/storage_path.dart';

class VideosProvider extends ChangeNotifier {
  int _videosSize = 0;
  List<VideoModel> _videosPath = [];
  List<Video> _videos = [];
  int get videosSize => _videosSize;
  List<VideoModel> get videosPath => _videosPath;
  List<Video> get videosFiles => _videos;
  bool showInFolders = false;
  VideoModel selectedVideoFolder;

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

  void onTap(VideoModel videoModel) {
    selectedVideoFolder = videoModel;
    notifyListeners();
  }

  Future<void> videos() async {
    final videosPath = await StoragePath.videoPath;
    final videos = await FileUtils.worker.doWork(FileUtils.storagePathVideos, videosPath);
    _videosPath = videos['videoModel'];
    _videosSize = videos['size'];
    _videos = videos['videos'];
    print('_videosPath length :${_videosPath.length}');
    notifyListeners();
  }
}
