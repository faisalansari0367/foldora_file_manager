import 'dart:io';

import 'package:files/pages/Drive/drive_files_selector.dart';
import 'package:files/provider/MyProvider.dart';
import 'package:files/provider/drive_provider.dart';
import 'package:files/services/gdrive/base_drive.dart';
import 'package:files/sizeConfig.dart';
import 'package:files/utilities/MyColors.dart';
import 'package:files/widgets/ListBuilder.dart';
import 'package:files/widgets/MediaListItem.dart';
import 'package:files/widgets/my_annotated_region.dart';
import 'package:files/widgets/my_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomSheetWidget extends StatefulWidget {
  const BottomSheetWidget({Key key}) : super(key: key);

  @override
  _BottomSheetWidgetState createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final driveProvider = Provider.of<DriveProvider>(context, listen: true);
    final myProvider = Provider.of<MyProvider>(context, listen: false);
    return MyAnnotatedRegion(
      systemNavigationBarColor: MyColors.darkGrey,
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return Container(
            // padding: EdgeInsets.symmetric(horizontal: 8.width, vertical: 4.height),
            color: Colors.transparent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.padding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 3.height,
                      ),
                      TextField(
                        cursorColor: MyColors.appbarActionsColor,
                        cursorHeight: 25,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 1.width),
                          hintText: ' Folder Name',
                          hintStyle: TextStyle(
                            color: MyColors.appbarActionsColor,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 2.height,
                      ),
                      Text(
                        'Select files to upload',
                        style: theme.textTheme.subtitle1
                            .copyWith(color: MyColors.appbarActionsColor),
                      ),
                      SizedBox(
                        height: 2.height,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Consumer<DriveProvider>(
                    // selector: (p0, p1) => p1.currentPath,
                    builder: (context, value, chlid) {
                      return FutureBuilder(
                        future: myProvider.dirContents(value.currentPath),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<FileSystemEntity>> snapshot) {
                          return DriveFilesSelector(
                            controller: scrollController,
                            data: snapshot.data ?? [],
                            // onTap: (String path) {
                            //   driveProvider.storageDetails.first.currentPath = path;
                            // },
                            onTap: value.onTap,
                            // trailing: IconButton(
                            //   icon: Icon(Icons.circle_outlined),
                            //   onPressed: () {

                            //   },
                            selectedFiles: value.filesToUpload,
                            // ),
                            // isSelected: (file) =>
                            //     value.filesToUpload.contains(file),
                            onPressed: (path) {
                              value.addToSelectedFiles((path));
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
                SizedBox(height: 2.height),
                Center(
                  child: MyElevatedButton(
                    text: 'Upload files',
                    onPressed: () {
                      driveProvider.filesToUpload.forEach(
                        (element) {
                          MyDrive.uploadFileToGoogleDrive(element);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
