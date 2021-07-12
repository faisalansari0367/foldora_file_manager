import 'package:files/pages/MediaPage/sliver_appbar.dart';
import 'package:files/provider/MyProvider.dart';
import 'package:files/utilities/DataModel.dart';
import 'package:files/utilities/MyColors.dart';
import 'package:files/utilities/OperationsUtils.dart';
import 'package:files/widgets/FloatingActionButton.dart';
import 'package:files/widgets/ListBuilder.dart';
import 'package:files/widgets/MyAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import './MediaStorageInfo.dart';
import '../../provider/MyProvider.dart';
import '../../provider/OperationsProvider.dart';
import 'MediaFiles.dart';

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

  MediaPage({this.storage, this.spaceInfoIndex});

  @override
  _MediaPageState createState() => _MediaPageState();
}

class _MediaPageState extends State<MediaPage> with TickerProviderStateMixin {
  ScrollController _scrollController;
  ScrollController _listViewController;
  Operations operations;
  MyProvider provider;

  //.
  AnimationController controller;
  Animation<double> opacity;
  Animation<double> opacity1;
  Animation<double> opacity2;

  void initController() {
    controller = AnimationController(vsync: this, duration: Duration(seconds: 3));

    opacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          0.0,
          0.8,
          curve: Curves.ease,
        ),
      ),
    );
    opacity1 = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          0.3,
          0.6,
          curve: Curves.ease,
        ),
      ),
    );
    controller.forward();

    // opacity2 = Tween<double>(
    //   begin: 0.0,
    //   end: 1.0,
    // ).animate(
    //   CurvedAnimation(
    //     parent: controller,
    //     curve: Interval(
    //       0.6,
    //       1.0,
    //       curve: Curves.ease,
    //     ),
    //   ),
    // );
    // controller.forward();
  }

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(
      AppbarUtils.systemUiOverylay(backgroundColor: MyColors.darkGrey),
    );
    operations = Provider.of<Operations>(context, listen: false);
    provider = Provider.of<MyProvider>(context, listen: false);
    initController();
    provider.setScrollListener(operations.scrollListener);
    _scrollController = ScrollController();
    _listViewController = ScrollController()..addListener(_scrollListener);
    super.initState();
  }

  void _scrollListener() {
    var direction = _listViewController.position.userScrollDirection;
    operations.scrolledPixels = _listViewController.position.pixels;
    if (direction == ScrollDirection.forward) {
      operations.scrollListener(6);
    } else if (direction == ScrollDirection.reverse) {
      operations.scrollListener(0);
    }
  }

  @override
  void dispose() {
    print('mediapage disposed');
    controller.dispose();
    _listViewController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    final storage = widget.storage;
    // var start = 0.0;
    // var end = 0.0;
    final children = <Widget>[
      MediaStorageInfo(),
      MediaFiles(),
      DirectoryLister(path: storage.path),
    ];

    final consumer = Consumer<MyProvider>(
      builder: (context, value, child) {
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
        // return listView;

        return DirectoryLister(
          path: storage.currentPath,
          scrollController: _listViewController,
        );
      },
    );

    final WillPopScope willPopScope = WillPopScope(
      onWillPop: () => provider.onGoBack(context),
      child: consumer,
    );

    final csv = CustomScrollView(
      controller: _scrollController,
      scrollDirection: Axis.vertical,
      physics: NeverScrollableScrollPhysics(),
      slivers: [
        MySliverAppBar(),
        SliverFillRemaining(child: willPopScope),
      ],
    );

    return AnnotatedRegion(
      value: AppbarUtils.systemUiOverylay(backgroundColor: MyColors.darkGrey),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(child: csv),
        // backgroundColor: Colors.white,
        bottomNavigationBar: OperationsUtils.bottomNavigation(),
        floatingActionButton: const FAB(),
      ),
    );
  }
}
