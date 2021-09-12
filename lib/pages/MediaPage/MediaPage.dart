import 'package:files/pages/MediaPage/sliver_appbar.dart';
import 'package:files/provider/MyProvider.dart';
import 'package:files/provider/scroll_provider.dart';
import 'package:files/utilities/DataModel.dart';
import 'package:files/utilities/MyColors.dart';
import 'package:files/utilities/OperationsUtils.dart';
import 'package:files/widgets/FloatingActionButton.dart';
import 'package:files/widgets/ListBuilder.dart';
import 'package:files/widgets/MyAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

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
  final Data storage;
  final int spaceInfoIndex;

  const MediaPage({this.storage, this.spaceInfoIndex});

  @override
  _MediaPageState createState() => _MediaPageState();
}

class _MediaPageState extends State<MediaPage> with TickerProviderStateMixin {
  ScrollController _scrollController;
  ScrollController _listViewController;
  OperationsProvider operations;
  ScrollProvider scrollProvider;
  MyProvider provider;

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(
      AppbarUtils.systemUiOverylay(
        backgroundColor: MyColors.darkGrey,
        brightness: Brightness.light,
      ),
    );
    scrollProvider = Provider.of<ScrollProvider>(context, listen: false);
    provider = Provider.of<MyProvider>(context, listen: false);
    provider.setScrollListener(scrollProvider.scrollListener);
    _scrollController = ScrollController();
    _listViewController = ScrollController()..addListener(_scrollListener);
    super.initState();
  }

  void _scrollListener() {
    final direction = _listViewController.position.userScrollDirection;
    if (direction == ScrollDirection.forward) {
      scrollProvider.scrollListener(6);
    } else if (direction == ScrollDirection.reverse) {
      scrollProvider.scrollListener(0);
    }
  }

  @override
  void dispose() {
    print('mediapage disposed');
    _listViewController.removeListener(_scrollListener);
    _listViewController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final storage = widget.storage;
    final children = <Widget>[
      const MediaStorageInfo(),
      const MediaFiles(),
      AnimationConfiguration.synchronized(
        duration: const Duration(milliseconds: 375),
        child: SlideAnimation(
          verticalOffset: 50.0,
          child: FadeInAnimation(
            child: DirectoryLister(
              path: storage.path,
            ),
          ),
        ),
      ),
      // DirectoryLister(path: storage.path),
    ];

    return AnnotatedRegion(
      value: AppbarUtils.systemUiOverylay(
        backgroundColor: MyColors.darkGrey,
        brightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        bottomNavigationBar: OperationsUtils.bottomNavigation(),
        floatingActionButton: const FAB(),
        body: SafeArea(
          child: CustomScrollView(
            controller: _scrollController,
            scrollDirection: Axis.vertical,
            physics: NeverScrollableScrollPhysics(),
            slivers: [
              MySliverAppBar(),
              SliverFillRemaining(
                child: WillPopScope(
                  onWillPop: () => provider.onGoBack(context),
                  child: Consumer<MyProvider>(
                    builder: (context, value, child) {
                      final storage = value.data[value.currentPage];
                      if (storage.path == storage.currentPath) {
                        return ListView.builder(
                          shrinkWrap: true,
                          controller: _listViewController,
                          physics: BouncingScrollPhysics(),
                          itemCount: children.length,
                          itemBuilder: (context, index) {
                            return children[index];
                          },
                        );
                      }
                      final lister = DirectoryLister(
                        path: storage.currentPath,
                        scrollController: _listViewController,
                      );
                      return AnimationConfiguration.synchronized(
                        key: UniqueKey(),
                        duration: const Duration(milliseconds: 375),
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: lister,
                          ),
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
}
