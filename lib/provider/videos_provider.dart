import 'package:files/decoration/my_decoration.dart';
import 'package:files/pages/Videos/models/video_entity.dart';
import 'package:files/pages/Videos/models/video_file.dart';
import 'package:files/pages/Videos/models/video_folder.dart';
import 'package:files/sizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:storage_details/storage_details.dart';

class VideosProvider extends ChangeNotifier {
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  int _videosSize = 0;
  final List<VideoEntity> _selectedFiles = [];
  final List<VideoFolder> _videosFolder = [];
  final List<VideoFile> _videos = [];

  List<VideoEntity> get selectedFiles => _selectedFiles;

  VideoFolder selectedVideoFolder;
  bool showInFolders = true;

  int get videosSize => _videosSize;
  List<VideoFolder> get videosFolder => _videosFolder;
  List<VideoFile> get videosFiles => _videos;

  VideosProvider() {
    // videos();
    getVideos();
  }

  Future<void> getVideos() async {
    final List result = await StorageDetails.getVideos();
    var videoFiles = <VideoFile>[];
    var videoFolders = <VideoFolder>[];
    var folders = <String>[];

    for (Map item in result) {
      final folderName = item['folderName'];
      if (!folders.contains(folderName)) {
        folders.add(folderName);
      }
      final videoFile = VideoFile.fromMap(item);
      videoFiles.add(videoFile);
    }

    for (var item in folders) {
      final files = videosInAFolder(result, item);
      final folder = VideoFolder(files: files, folderName: item);
      _videosSize += folder.size;
      videoFolders.add(folder);
    }

    _videos.addAll(videoFiles);
    _videosFolder.addAll(videoFolders);
    notifyListeners();
  }

  void delete() {
    _selectedFiles.forEach((element) {
      if (element is VideoFile) {
        _remove(element);
      } else if (element is VideoFolder) {}
    });
    _selectedFiles.clear();

    // _selectedFiles.forEach((element) {
    //   _selectedFiles.remove(element);

    // });
  }

  int _getCurrentItemIndex(VideoFile file) {
    var index = 0;
    if (selectedVideoFolder == null) {
      index = videosFiles.indexOf(file);
    } else {
      index = selectedVideoFolder.files.indexOf(file);
    }
    return index;
  }

  void _removeCurrentItem(VideoFile file) {
    if (selectedVideoFolder == null) {
      videosFiles.remove(file);
    } else {
      selectedVideoFolder.files.remove(file);
      if (selectedVideoFolder.files.isEmpty) {
        _videosFolder.remove(selectedVideoFolder);
      }
    }
  }

  void _remove(VideoFile file) {
    final index = _getCurrentItemIndex(file);
    listKey.currentState.removeItem(index, _itemRemover, duration: MyDecoration.duration);
    _removeCurrentItem(file);
    // _selectedFiles.remove(file);
    Future.delayed(MyDecoration.duration, () => notifyListeners());
  }

  Widget _itemRemover(BuildContext context, Animation<double> animation) {
    return FadeTransition(
      opacity: animation,
      child: SizeTransition(
        sizeFactor: animation,
        child: SizedBox(height: 9.height),
      ),
    );
  }

  List<VideoFile> videosInAFolder(List data, String folderName) {
    var files = <VideoFile>[];
    for (var element in data) {
      final condition = element['folderName'] == folderName;
      if (condition) files.add(VideoFile.fromMap(element));
    }
    return files;
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

  void addOrRemoveVideos(VideoEntity entity) {
    final isExist = _selectedFiles.contains(entity);
    !isExist ? _selectedFiles.add(entity) : _selectedFiles.remove(entity);
    notifyListeners();
  }
}
