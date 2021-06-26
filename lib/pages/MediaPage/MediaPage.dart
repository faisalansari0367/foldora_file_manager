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

class _MediaPageState extends State<MediaPage> with SingleTickerProviderStateMixin {
  ScrollController _scrollController;
  ScrollController _listViewController;

  //.
  @override
  void initState() {
    final operations = Provider.of<Operations>(context, listen: false);
    final provider = Provider.of<MyProvider>(context, listen: false);
    provider.setScrollListener(operations.scrollListener);

    super.initState();
    _scrollController = ScrollController();
    _listViewController = ScrollController()..addListener(_scrollListener);
  }

  _scrollListener() {
    final provider = Provider.of<Operations>(context, listen: false);
    var direction = _listViewController.position.userScrollDirection;
    provider.scrolledPixels = _listViewController.position.pixels;
    if (direction == ScrollDirection.forward) {
      provider.scrollListener(6);
    } else if (direction == ScrollDirection.reverse) {
      provider.scrollListener(0);
    }
  }

  @override
  void dispose() {
    print('mediapage disposed');
    _listViewController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    final provider = Provider.of<MyProvider>(context, listen: false);
    final storage = widget.storage;

    List<Widget> children = <Widget>[
      MediaStorageInfo(),
      MediaFiles(),
      DirectoryLister(path: storage.path),
    ];

    final listView = ListView.builder(
      shrinkWrap: true,
      controller: _listViewController,
      physics: BouncingScrollPhysics(),
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );

    final consumer = Consumer<MyProvider>(
      builder: (context, value, child) {
        if (storage.path == storage.currentPath) {
          return listView;
        } else {
          return DirectoryLister(
            path: storage.currentPath,
            scrollController: _listViewController,
          );
        }
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
      value: AppbarUtils.systemUiOverylay(MyColors.darkGrey),
      child: Scaffold(
        body: SafeArea(child: csv),
        backgroundColor: Colors.white,
        bottomNavigationBar: OperationsUtils.bottomNavigation(),
        floatingActionButton: FAB(),
      ),
    );
  }
}
