import 'package:cached_network_image/cached_network_image.dart';
import 'package:files/provider/drive_provider.dart';
import 'package:files/services/gdrive/base_drive.dart';
import 'package:files/utilities/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/drive/v3.dart';
import 'package:provider/provider.dart';

import '../../sizeConfig.dart';
import 'description.dart';
import 'drive_list_item.dart';

class DriveFutureBuilder extends StatelessWidget {
  final String fileId;
  const DriveFutureBuilder({Key key, this.fileId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DriveProvider>(context);
    if (provider.isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    // return FutureBuilder(
    //   future: provider.getDriveFiles(fileId: fileId),
    //   builder: (BuildContext context, AsyncSnapshot snapshot) {

    return Container(
      color: Colors.white,
      child: ListView.builder(
        controller: ScrollController(),
        // physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: provider.driveFiles.length,
        itemBuilder: (context, index) {
          final file = provider.driveFiles[index];
          return DriveListItem(
            title: file.name,
            ontap: () => provider.getDriveFiles(fileId: file.id),
            description: Description(bytes: file.size, createdTime: file.createdTime),
            leading: Container(
              decoration: BoxDecoration(
                color: MyColors.darkGrey,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Container(
                height: Responsive.imageSize(11),
                width: Responsive.imageSize(11),
                child: file.mimeType == MyDrive.mimeTypeFolder
                    ? Icon(
                        Icons.folder_open,
                        size: Responsive.imageSize(5),
                        color: Colors.white,
                      )
                    : CachedNetworkImage(
                        imageUrl: file.thumbnailLink,
                      ),
              ),
            ),
          );
        },
      ),
    );
    //   },
    // );
  }
}
