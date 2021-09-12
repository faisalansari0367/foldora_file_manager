import 'dart:io';

import 'package:files/provider/StoragePathProvider.dart';
import 'package:files/sizeConfig.dart';
import 'package:files/utilities/MyColors.dart';
import 'package:files/widgets/MyAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class FullScreenImage extends StatefulWidget {
  final int index;
  final File file;
  const FullScreenImage({this.index, this.file});

  @override
  _FullScreenImageState createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  PageController controller;
  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: widget.index);
    final provider = Provider.of<StoragePathProvider>(context, listen: false);
    provider.updatePageViewCurrentIndex(widget.index);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StoragePathProvider>(context, listen: false);
    // bool fullScreen = true;
    // int index = 0;
    return WillPopScope(
      onWillPop: () async {
        await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
        Navigator.pop(context);
        return true;
      },
      child: AnnotatedRegion(
        value: SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []),
        child: AnnotatedRegion(
          value: AppbarUtils.systemUiOverylay(),
          child: Scaffold(
            backgroundColor: Colors.black,
            body: SafeArea(
              child: Stack(
                // fit: StackFit.expand,
                children: [
                  PageView.builder(
                    physics: BouncingScrollPhysics(),
                    controller: controller,
                    itemCount: provider.imagesPath.length,
                    onPageChanged: provider.updatePageViewCurrentIndex,
                    itemBuilder: (context, index) {
                      // final image = provider.imagesPath[index];

                      print(provider.pageViewCurrentIndex);
                      print('index of current photo : $index');
                      return InteractiveViewer(
                        minScale: 1.0,
                        maxScale: 100.0,
                        child: Image.file(
                          widget.file,
                          fit: BoxFit.contain,
                          cacheWidth: 1080,
                        ),
                      );
                    },
                  ),
                  Positioned(
                    bottom: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: Responsive.widthMultiplier * 15,
                        ),
                        button(
                          Icons.delete_outline_rounded,
                          onPressed: () {
                            provider.deleteAndUpdateImage(controller);
                          },
                        ),
                        SizedBox(
                          width: Responsive.widthMultiplier * 15,
                        ),
                        button(Icons.share_rounded),
                        SizedBox(
                          width: Responsive.widthMultiplier * 15,
                        ),
                        button(Icons.info_outline_rounded),
                        SizedBox(
                          width: Responsive.widthMultiplier * 15,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void setOverlay() {
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
    SystemUiOverlay.bottom,
    SystemUiOverlay.top,
  ]);
}

void resetOverlay() {
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
}

IconButton button(IconData iconData, {onPressed}) {
  return IconButton(
    padding: EdgeInsets.all(10),
    onPressed: onPressed ?? () {},
    icon: Icon(
      iconData,
      color: MyColors.whitish,
      size: Responsive.imageSize(6),
    ),
  );
}

class MyPageView extends StatefulWidget {
  final int index;
  final File file;
  const MyPageView({Key key, this.index, this.file}) : super(key: key);

  @override
  _MyPageViewState createState() => _MyPageViewState();
}

class _MyPageViewState extends State<MyPageView> {
  PageController pageController;
  @override
  void initState() {
    pageController = PageController(initialPage: widget.index);
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StoragePathProvider>(context, listen: false);
    return PageView.builder(
      physics: BouncingScrollPhysics(),
      controller: pageController,
      onPageChanged: provider.updatePageViewCurrentIndex,
      itemBuilder: (context, index) {
        return Image.file(
          // provider.imagesPath[index],
          widget.file,
          cacheWidth: 1080,
        );
      },
    );
  }
}
