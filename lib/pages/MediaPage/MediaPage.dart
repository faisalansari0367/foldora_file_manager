import 'package:files/decoration/my_bottom_sheet.dart';
import 'package:files/decoration/my_decoration.dart';
import 'package:files/pages/MediaPage/sliver_appbar.dart';
import 'package:files/provider/MyProvider.dart';
import 'package:files/provider/scroll_provider.dart';
import 'package:files/services/file_system/file_system.dart';
import 'package:files/utilities/DataModel.dart';
import 'package:files/utilities/MyColors.dart';
import 'package:files/utilities/OperationsUtils.dart';
import 'package:files/utilities/Utils.dart';
import 'package:files/widgets/FloatingActionButton.dart';
import 'package:files/widgets/ListBuilder.dart';
import 'package:files/widgets/animated_widgets/my_slide_animation.dart';
import 'package:files/widgets/menu_options/create_folder_widget.dart';
import 'package:files/widgets/menu_options/option_with_icon_widget.dart';
import 'package:files/widgets/my_annotated_region.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import './MediaStorageInfo.dart';
import '../../provider/MyProvider.dart';
import '../../provider/OperationsProvider.dart';
import 'MediaFiles.dart';

// necessary things to complete this app
// need more features
//

// define the work to do
// issues that need to be fixed
// this is what needs to be fixed at priority file observer crashing the app...
// photos should notify whenever a change happen...
// file operations should happen in a service..
// add options to encrypt and decrypt files
// add feature to open pdf zip
// show and hide FileSystemEntity
// add a video player
// create a music player ui
// features to add fingerprint and face authentication
// remove the lags

class MediaPage extends StatefulWidget {
  final Data? storage;
  final int? spaceInfoIndex;

  const MediaPage({this.storage, this.spaceInfoIndex});

  @override
  _MediaPageState createState() => _MediaPageState();
}

class _MediaPageState extends State<MediaPage> {
  ScrollController? _scrollController, _listViewController;
  OperationsProvider? operations;
  late ScrollProvider scrollProvider;
  late MyProvider provider;
  AnimationController? controller;

  static const decoration = MyDecoration.showMediaStorageBackground;
  @override
  void initState() {
    scrollProvider = Provider.of<ScrollProvider>(context, listen: false);
    operations = Provider.of<OperationsProvider>(context, listen: false);
    provider = Provider.of<MyProvider>(context, listen: false);

    provider.setScrollListener(scrollProvider.scrollListener);
    _scrollController = ScrollController();
    _listViewController = ScrollController()..addListener(_scrollListener);
    super.initState();
  }

  void _scrollListener() {
    final direction = _listViewController!.position.userScrollDirection;
    if (direction == ScrollDirection.forward) {
      scrollProvider.scrollListener(6);
    } else if (direction == ScrollDirection.reverse) {
      scrollProvider.scrollListener(0);
    }
  }

  @override
  void dispose() {
    print('mediapage disposed');
    _listViewController!.removeListener(_scrollListener);
    _listViewController!.dispose();
    _scrollController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final storage = widget.storage!;
    final children = <Widget>[
      MediaStorageInfo(
        availableBytes: storage.free,
        totalBytes: storage.total,
        usedBytes: storage.used,
        storageName: 'Media',
      ),
      const MediaFiles(
        filesName: 'Internal Storage',
      ),
      MySlideAnimation(
        child: DirectoryLister(
          path: storage.path,
        ),
      ),
    ];

    return MyAnnotatedRegion(
      statusBarColor: MyColors.darkGrey,
      // systemNavigationBarColor: MyColors.darkGrey,
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        bottomNavigationBar: OperationsUtils.bottomNavigation(),
        floatingActionButton: FAB(
          onPressed: fabOnpressed,
        ),
        body: SafeArea(
          child: CustomScrollView(
            controller: _scrollController,
            scrollDirection: Axis.vertical,
            physics: NeverScrollableScrollPhysics(),
            slivers: [
              MySliverAppBar(
                title: Consumer<OperationsProvider>(
                  builder: (context, provider, child) {
                    final value = provider.selectedMedia;
                    final size = FileUtils.formatBytes(provider.selectedItemSizeBytes, 2);
                    // final getData = operations.getFiles(value);
                    if (value.isEmpty) return Container();
                    final file = value.length > 1 ? 'files' : 'file';
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${value.length} $file selected',
                          style: Theme.of(context).textTheme.subtitle1!.copyWith(
                                color: MyColors.appbarActionsColor,
                              ),
                        ),
                        SizedBox(height: 5),
                        if (provider.selectedItemSizeBytes != 0)
                          Text(
                            '$size',
                            style: Theme.of(context)
                                .textTheme
                                .caption!
                                .copyWith(color: MyColors.appbarActionsColor!.withOpacity(1.0)),
                          ),
                      ],
                    );
                  },
                  // selector: (p0, p1) => p1.selectedMedia,
                ),
              ),
              SliverFillRemaining(
                child: WillPopScope(
                  onWillPop: () => provider.onGoBack(context),
                  child: Consumer<MyProvider>(
                    builder: (context, value, child) {
                      final storage = value.data[value.currentPage];
                      if (storage.path == storage.currentPath) {
                        return Container(
                          decoration: decoration,
                          child: ListView.builder(
                            shrinkWrap: true,
                            controller: _listViewController,
                            physics: BouncingScrollPhysics(),
                            itemCount: children.length,
                            itemBuilder: (context, index) {
                              return children[index];
                            },
                          ),
                        );
                      }
                      return MySlideAnimation(
                        key: UniqueKey(),
                        child: DirectoryLister(
                          path: storage.currentPath,
                          scrollController: _listViewController,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> fabOnpressed() async {
    final children = <OptionIcon>[
      OptionIcon(
        name: 'Create folder',
        iconData: Icons.create_new_folder_outlined,
        onTap: () => {
          Navigator.pop(context),
          MyBottomSheet.bottomSheet(
            context,
            controller: controller,
            child: CreateFolder(
              onChanged: provider.onChangeFolder,
              onPressed: () {
                final path = provider.data.elementAt(provider.currentPage).currentPath!;
                FileSystem.createDir(path, provider.newFolderName);
                Navigator.pop(context);
              },
            ),
          ),
        },
      ),
      OptionIcon(
        name: 'Create file',
        iconData: Icons.upload_file_outlined,
        onTap: () => {
          Navigator.pop(context),
          MyBottomSheet.bottomSheet(
            context,
            child: CreateFolder(
              hintText: 'File name',
              buttonText: 'Create file',
              onChanged: provider.onChangeFolder,
              onPressed: () {
                final path = provider.data.elementAt(provider.currentPage).currentPath!;
                FileSystem.createFile(path, provider.newFolderName);
                Navigator.pop(context);
              },
            ),
          ),
        },
      ),
    ];
    await MyBottomSheet.options(context, children);
  }
}
