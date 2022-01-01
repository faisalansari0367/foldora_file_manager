import 'package:files/decoration/my_decoration.dart';
import 'package:files/pages/Drive/future_builder.dart';
import 'package:files/pages/Drive/my_bottom_sheet.dart';
import 'package:files/pages/MediaPage/MediaFiles.dart';
import 'package:files/pages/MediaPage/MediaStorageInfo.dart';
import 'package:files/provider/drive_provider/drive_provider.dart';
import 'package:files/utilities/MyColors.dart';
import 'package:files/widgets/MyAppBar.dart';
import 'package:files/widgets/my_annotated_region.dart';
import 'package:files/widgets/nav_rail/nav_rail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/drive/v3.dart' show AboutStorageQuota;
import 'package:provider/provider.dart';

import '../../sizeConfig.dart';
import 'bottom_sheet_widget.dart';
import 'drive_options.dart';

class DriveScreen extends StatefulWidget {
  const DriveScreen({Key key, User user}) : super(key: key);

  @override
  _DriveScreenState createState() => _DriveScreenState();
}

class _DriveScreenState extends State<DriveScreen> {
  ScrollController controller;

  @override
  void initState() {
    super.initState();
    controller = ScrollController();
    init();
  }

  Future<void> init() async {
    final driveProvider = Provider.of<DriveProvider>(context, listen: false);
    await driveProvider.initDrive(context);
    await driveProvider.getDriveFiles();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final driveProvider = Provider.of<DriveProvider>(context, listen: false);
    driveProvider.setContext(context);
    return MyAnnotatedRegion(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: MyColors.teal,
          onPressed: () {
            MyBottomSheet.bottomSheet(
              context,
              child: BottomSheetWidget(),
            );
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        backgroundColor: MyColors.white,
        appBar: MyAppBar(
          bottomNavBar: true,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(12.height),
            child: Consumer<DriveProvider>(
              builder: (context, value, child) {
                return NavRail(
                  data: value.navRail,
                  selectedIndex: driveProvider.selectedIndex,
                  onTap: value.onTapNavItem,
                );
              },
            ),
          ),
          // b
        ),
        body: Container(
          decoration: MyDecoration.showMediaStorageBackground,
          child: SingleChildScrollView(
            controller: controller,
            physics: MyDecoration.physics,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Selector<DriveProvider, AboutStorageQuota>(
                  selector: (p0, p1) => p1.driveQuota,
                  builder: (context, quota, child) {
                    final total = int.parse(quota?.limit ?? '0');
                    final usage = int.parse(quota?.usageInDrive ?? '0');
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
                MediaFiles(filesName: 'Drive Files', menu: DriveMenuOptions()),
                Container(
                  color: MyColors.white,
                  child: Selector<DriveProvider, int>(
                    selector: (p0, p1) => p1.selectedIndex,
                    builder: (context, value, child) {
                      final fileId = driveProvider.navRail[value].id;
                      return WillPopScope(
                        onWillPop: driveProvider.onWillPop,
                        child: DriveFutureBuilder(
                          key: UniqueKey(),
                          controller: controller,
                          fileId: fileId,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
