import 'package:files/decoration/my_bottom_sheet.dart';
import 'package:files/decoration/my_decoration.dart';
import 'package:files/helpers/provider_helpers.dart';
import 'package:files/pages/Drive/drive_fab.dart';
import 'package:files/pages/Drive/drive_listview_builder.dart';
import 'package:files/pages/MediaPage/MediaFiles.dart';
import 'package:files/pages/MediaPage/MediaStorageInfo.dart';
import 'package:files/provider/drive_provider/drive_provider.dart';
import 'package:files/services/gdrive/auth.dart';
import 'package:files/utilities/MyColors.dart';
import 'package:files/widgets/MyAppBar.dart';
import 'package:files/widgets/my_annotated_region.dart';
import 'package:files/widgets/nav_rail/nav_rail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/drive/v3.dart' show AboutStorageQuota;
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import '../../sizeConfig.dart';
import 'drive_options.dart';

class DriveScreen extends StatefulWidget {
  const DriveScreen({Key? key, User? user}) : super(key: key);

  @override
  _DriveScreenState createState() => _DriveScreenState();
}

class _DriveScreenState extends State<DriveScreen> with SingleTickerProviderStateMixin {
  ScrollController? controller;
  // AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    controller = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      init();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<void> signingIn() async {
    final textTheme = ThemeData.dark().textTheme;
    await MyBottomSheet.bottomSheet(
      context,
      child: Padding(
        padding: EdgeInsets.only(
          top: 5.padding,
          right: 5.width,
          left: 5.width,
          bottom: 5.padding,
        ),
        child: Row(
          children: [
            SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 1,
              ),
            ),
            SizedBox(width: 5.width),
            Text(
              'Signing in please wait...',
              style: textTheme.bodyText2,
            )
          ],
        ),
      ),
    );
  }

  Future<void> init() async {
    final driveProvider = getProvider<DriveProvider>(context);
    // ignore: unawaited_futures
    signingIn();
    await Auth.initializeFirebase();
    // await driveProvider.getDriveFiles();
    Navigator.pop(context);
    await driveProvider.init();
  }

  @override
  void dispose() {
    // _animationController.dispose();
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final driveProvider = getProvider<DriveProvider>(context);
    driveProvider.setContext(context);
    return MyAnnotatedRegion(
      child: Scaffold(
        floatingActionButton: DriveFab(),
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
        ),
        body: Container(
          decoration: MyDecoration.showMediaStorageBackground,
          child: SingleChildScrollView(
            physics: MyDecoration.physics,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Selector<DriveProvider, AboutStorageQuota?>(
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
                  child: WillPopScope(
                    onWillPop: driveProvider.onWillPop,
                    child: Selector<DriveProvider, Tuple2<int, bool>>(
                      selector: (p0, p1) => Tuple2(p1.selectedIndex, p1.showAllFiles),
                      builder: (context, data, child) {
                        final value = data.item1;
                        final fileId = driveProvider.navRail[value].id;
                        return DriveFutureBuilder(
                          key: UniqueKey(),
                          controller: controller,
                          fileId: fileId,
                          showAllFiles: data.item2,
                        );
                      },
                    ),
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
