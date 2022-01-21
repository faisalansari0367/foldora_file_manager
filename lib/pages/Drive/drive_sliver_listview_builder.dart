import 'package:files/pages/Drive/drive_sliver_listview.dart';
import 'package:files/provider/drive_provider/drive_deleter_provider.dart';
import 'package:files/provider/drive_provider/drive_downloader_provider.dart';
import 'package:files/provider/drive_provider/drive_provider.dart';
import 'package:files/services/gdrive/base_drive.dart';
import 'package:files/services/gdrive/drive_storage.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/drive/v3.dart' show File;
import 'package:provider/provider.dart';

class DriveSliverFutureBuilder extends StatefulWidget {
  final String fileId;
  final ScrollController controller;
  final bool showAllFiles;

  const DriveSliverFutureBuilder({
    Key key,
    this.fileId,
    this.controller,
    this.showAllFiles = false,
  }) : super(key: key);

  @override
  State<DriveSliverFutureBuilder> createState() => _DriveSliverFutureBuilderState();
}

class _DriveSliverFutureBuilderState extends State<DriveSliverFutureBuilder> {
  bool _isLoading = false;
  var _data = <File>[];
  DriveStorage storage;

  @override
  void initState() {
    storage = DriveStorage();
    super.initState();
    getFromCache();
    init();
  }

  void init() async {
    setLoading(true);
    final provider = Provider.of<DriveProvider>(context, listen: false);
    _data = await provider.getDriveFiles(fileId: widget.fileId);
    setLoading(false);
    await saveToCache();
  }

  Future<void> saveToCache() async {
    final json = _data.map((e) => e.toJson()).toList();
    await storage.saveDriveFiles(widget.fileId ?? '0', json);
  }

  Future<void> getFromCache() async {
    if (!_isLoading) setLoading(true);
    final sw = Stopwatch()..start();
    final data = await storage.getDriveFiles(widget.fileId ?? '0');
    if (data == null) return;
    try {
      _data = data.map((e) => File.fromJson(e)).toList();
      setState(() {});
    } catch (e) {
      print('some fucking stupid error $e');
      rethrow;
    }
    if (_data.isNotEmpty) setLoading(false);
    print('getting data from cache took ${sw.elapsedMicroseconds}');
    sw.stop();
  }

  @override
  void setState(VoidCallback fn) {
    if (!mounted) return;
    super.setState(fn);
  }

  void setLoading(bool value) {
    _isLoading = value;
    setState(() {});
  }

  @override
  void dispose() {
    _data.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DriveSliverListview(
      controller: widget.controller,
      data: _data,
      onTap: (file) => onTap(file, context),
      onTapIcon: onTapIcon,
    );
  }

  void onTapIcon(File file) {
    final provider = Provider.of<DriveDeleter>(context, listen: false);
    provider.addAndRemoveFile(file.id);
  }

  Future<void> onTap(File file, context) async {
    final provider = Provider.of<DriveProvider>(context, listen: false);
    if (file.mimeType == MyDrive.mimeTypeFolder) {
      provider.addNavRail(file.name, file.id);
      await provider.getDriveFiles(fileId: file.id);
    } else {
      final driveDownloader = Provider.of<DriveDownloader>(context, listen: false);
      final isDownloaded = driveDownloader.isFileAlreadyDownloaded(file.name);
      if (isDownloaded) return;
      await driveDownloader.downloadFile(
        file.name,
        file.id,
        file.size,
      );
    }
  }
}
