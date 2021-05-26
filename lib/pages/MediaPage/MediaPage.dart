import 'package:files/provider/MyProvider.dart';
import 'package:files/utilities/DataModel.dart';
import 'package:files/utilities/MyColors.dart';
import 'package:files/utilities/OperationsUtils.dart';
import 'package:files/widgets/FloatingActionButton.dart';
import 'package:files/widgets/ListBuilder.dart';
import 'package:files/widgets/MediaPageAppbar.dart';
import 'package:files/widgets/MyAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../sizeConfig.dart';
import './MediaStorageInfo.dart';
import '../../provider/MyProvider.dart';
import '../../provider/OperationsProvider.dart';
import '../../widgets/MyDropDown.dart';
import '../../widgets/Search.dart';
import 'MediaFiles.dart';

class MediaPage extends StatefulWidget {
  final Data storage;
  final int spaceInfoIndex;

  MediaPage({this.storage, this.spaceInfoIndex});

  @override
  _MediaPageState createState() => _MediaPageState();
}

class _MediaPageState extends State<MediaPage>
    with SingleTickerProviderStateMixin {
  ScrollController _scrollController;
  ScrollController _listViewController;
  AnimationController _controller;
  Animation animation;
  Animation opacity;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    animation = Tween<Offset>(
      begin: Offset(0, -1.0),
      end: Offset(0.0, 0.0),
    ).animate(_controller);
    opacity = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    _scrollController = ScrollController();
    _listViewController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  _scrollListener() {
    final provider = Provider.of<Operations>(context, listen: false);
    var direction = _scrollController.position.userScrollDirection;
    provider.scrolledPixels = _scrollController.position.pixels;
    if (direction == ScrollDirection.forward) {
      provider.scrollListener(12, true);
    } else if (direction == ScrollDirection.reverse) {
      provider.scrollListener(6, false);
    }
  }

  @override
  void dispose() {
    print('mediapage disposed');
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _listViewController.dispose();
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

    final listView = ListView(
      shrinkWrap: true,
      controller: _listViewController,
      physics: BouncingScrollPhysics(),
      children: children,
    );

    final WillPopScope willPopScope = WillPopScope(
      onWillPop: () => provider.onGoBack(context),
      child: Consumer<MyProvider>(
        builder: (context, value, child) {
          return storage.path == storage.currentPath
              ? listView
              : DirectoryLister(path: storage.currentPath);
        },
      ),
    );

    final pop = () => Navigator.pop(context);
    final showSearchFunction = () async => await showSearch(
          context: context,
          delegate: Search(),
        );
    final actions = [
      AppbarUtils.icon(context, Icon(Icons.search), showSearchFunction),
      MyDropDown()
    ];

    final csv = CustomScrollView(
      controller: _scrollController,
      scrollDirection: Axis.vertical,
      slivers: [
        SliverAppBar(
          floating: true,
          pinned: true,
          backgroundColor: MyColors.darkGrey,
          leading: AppbarUtils.icon(context, Icon(Icons.arrow_back), pop),
          actions: actions,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(6 * Responsive.heightMultiplier),
            child: MyBottomAppBar(backgroundColor: Colors.transparent),
          ),
        ),
        SliverFillRemaining(child: willPopScope),
        // SliverToBoxAdapter(child: willPopScope),
      ],
    );

    return AnnotatedRegion(
      value: SystemUiOverlayStyle(statusBarColor: MyColors.darkGrey),
      child: Scaffold(
        body: SafeArea(child: csv),
        bottomNavigationBar: OperationsUtils.bottomNavigation(),
        floatingActionButton: FAB(),
      ),
    );
  }
}
