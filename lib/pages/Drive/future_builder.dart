import 'package:files/decoration/my_decoration.dart';
import 'package:files/pages/Drive/list_view_switcher.dart';
import 'package:files/provider/drive_provider/drive_downloader_provider.dart';
import 'package:files/provider/drive_provider/drive_provider.dart';
import 'package:files/services/gdrive/base_drive.dart';
import 'package:files/services/gdrive/leading_widget/leading_drive.dart';
import 'package:files/widgets/animated_widgets/my_slide_animation.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/drive/v3.dart' show File;
import 'package:provider/provider.dart';

import 'description.dart';
import 'drive_list_item.dart';

class DriveFutureBuilder extends StatefulWidget {
  final String fileId;
  final ScrollController controller;

  const DriveFutureBuilder({
    Key key,
    this.fileId,
    this.controller,
  }) : super(key: key);

  @override
  State<DriveFutureBuilder> createState() => _DriveFutureBuilderState();
}

class _DriveFutureBuilderState extends State<DriveFutureBuilder> {
  bool _isLoading = false;
  var _data = <File>[];

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    print('init function called');
    _data.clear();
    setLoading(true);
    final provider = Provider.of<DriveProvider>(context, listen: false);
    _data = await provider.getDriveFiles(fileId: widget.fileId);
    setLoading(false);
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
    return MySlideAnimation(
      curve: MyDecoration.curve,
      child: ListViewSwitcher(
        isLoading: _isLoading,
        child: DriveListview(
          controller: widget.controller,
          data: _data,
          onTap: (file) => onTap(file, context),
        ),
      ),
    );
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

class DriveListview extends StatelessWidget {
  final ScrollController controller;
  final List<File> data;
  final Function(File) onTap;

  const DriveListview({Key key, this.controller, this.data, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller ?? ScrollController(),
      shrinkWrap: true,
      itemCount: data.length,
      itemBuilder: (context, index) {
        final file = data[index];
        return DriveListItem(
          title: Text(
            file.name,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          ontap: () => onTap(file),
          description: Description(
            bytes: file.size,
            createdTime: file.createdTime,
          ),
          leading: LeadingDrive(
            id: file.id,
            extension: file.fullFileExtension,
            iconLink: file.iconLink.replaceAll('/16/', '/64/'),
          ),
        );
      },
    );
  }
}
