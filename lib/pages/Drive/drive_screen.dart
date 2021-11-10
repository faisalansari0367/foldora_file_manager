import 'package:files/decoration/my_decoration.dart';
import 'package:files/pages/MediaPage/MediaFiles.dart';
import 'package:files/pages/MediaPage/MediaStorageInfo.dart';
import 'package:files/provider/drive_provider.dart';
import 'package:files/services/gdrive/base_drive.dart';
import 'package:files/utilities/MyColors.dart';
import 'package:files/widgets/MyAppBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/drive/v3.dart' show About, AboutStorageQuota, File;
import 'package:provider/provider.dart';

import '../../sizeConfig.dart';
import 'list_item.dart';

class DriveScreen extends StatefulWidget {
  const DriveScreen({Key key, User user}) : super(key: key);

  @override
  _DriveScreenState createState() => _DriveScreenState();
}

class _DriveScreenState extends State<DriveScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final driveProvider = Provider.of<DriveProvider>(context, listen: false);
    driveProvider.setContext(context);
    return Scaffold(
      appBar: MyAppBar(),
      body: Container(
        decoration: MyDecoration.showMediaStorageBackground,
        child: SingleChildScrollView(
          controller: ScrollController(),
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Selector<DriveProvider, AboutStorageQuota>(
                selector: (p0, p1) => p1.driveQuota,
                builder: (context, quota, child) {
                  if (quota == null) {
                    return MediaStorageInfo(
                      storageName: 'Drive',
                      path: 'assets/drive.png',
                    );
                  }
                  final total = int.parse(quota.limit);
                  final usage = int.parse(quota.usageInDrive);
                  final available = total - usage;
                  return MediaStorageInfo(
                    availableBytes: available,
                    totalBytes: total,
                    usedBytes: usage,
                    storageName: 'Drive',
                    path: 'assets/drive.png',
                  );
                },
              ),
              // const MediaStorageInfo(),
              const MediaFiles(filesName: 'Drive Files'),
              FutureBuilder(
                future: driveProvider.getDriveFiles(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                  return Container(
                    color: Colors.white,
                    child: ListView.builder(
                      controller: ScrollController(),
                      // physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        final File file = snapshot.data[index];
                        return DriveListItem(
                          title: file.name,
                          leading: Container(
                            decoration: BoxDecoration(
                              color: MyColors.darkGrey,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Container(
                              height: Responsive.imageSize(11),
                              width: Responsive.imageSize(11),
                              child: Icon(
                                Icons.folder_open,
                                size: Responsive.imageSize(5),
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
