import 'package:files/pages/Drive/list_view_switcher.dart';
import 'package:files/provider/drive_downloader_provider.dart';
import 'package:files/provider/drive_provider.dart';
import 'package:files/services/gdrive/base_drive.dart';
import 'package:files/services/gdrive/leading_widget/leading_drive.dart';
import 'package:files/utilities/my_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'description.dart';
import 'drive_list_item.dart';

class DriveFutureBuilder extends StatelessWidget {
  final String fileId;
  final ScrollController controller;
  const DriveFutureBuilder({
    Key key,
    this.fileId,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DriveProvider>(context);
    // var widget;
    // if (provider.isLoading) {
    //   widget = Container(
    //     color: MyColors.white,
    //     child: Column(
    //       children: [
    //         SizedBox(
    //           height: 20.height,
    //           child: Center(
    //             child: CircularProgressIndicator(
    //               color: MyColors.teal,
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //   );
    //   // return DriveListItemPlaceholder();
    // }
    // return FutureBuilder(
    //   future: provider.getDriveFiles(fileId: fileId),
    //   builder: (BuildContext context, AsyncSnapshot snapshot) {

    return Container(
      color: Colors.white,
      child: ListViewSwitcher(
        isLoading: provider.isLoading,
        child: ListView.builder(
          controller: controller ?? ScrollController(),
          shrinkWrap: true,
          itemCount: provider.driveFiles.length,
          itemBuilder: (context, index) {
            final file = provider.driveFiles[index];
            return WillPopScope(
              onWillPop: () {
                if (provider.selectedIndex == 0) {
                  return Future.value(true);
                }
                provider.getDriveFiles(
                  fileId: provider.navRail[provider.selectedIndex - 1].id,
                );
                provider.setSelectedIndex(provider.selectedIndex - 1);
                return Future.value(false);
              },
              child: DriveListItem(
                title: Text(
                  file.name,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                ontap: () async {
                  if (file.mimeType == MyDrive.mimeTypeFolder) {
                    provider.addNavRail(file.name, file.id);
                    await provider.getDriveFiles(fileId: file.id);
                  } else {
                    MySnackBar.show(context,
                        content: '${file.name} is started downloading...');
                    final driveDownloader =
                        Provider.of<DriveDownloader>(context, listen: false);

                    await driveDownloader.downloadFile(
                        file.originalFilename, file.id, file.size);
                    MySnackBar.show(context,
                        content: '${file.name} download complete');
                  }
                },
                description: Description(
                  bytes: file.size,
                  createdTime: file.createdTime,
                ),
                leading: LeadingDrive(
                  id: file.id,
                  extension: file.fullFileExtension,
                  iconLink: file.iconLink.replaceAll('/16/', '/64/'),
                ),
              ),
            );
          },
        ),
      ),
    );

    // return widget;
    //   },
    // );
  }
}
