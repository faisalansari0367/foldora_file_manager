// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:io';

import 'package:files/provider/storage_path_provider.dart';
import 'package:files/sizeConfig.dart';
import 'package:files/widgets/MyAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class FullScreenImage extends StatefulWidget {
  final int index;
  final List<File> files;
  const FullScreenImage({this.index, this.files});

  @override
  _FullScreenImageState createState() => _FullScreenImageState();
}

const duration = Duration(milliseconds: 375);
const curve = Curves.decelerate;

class _FullScreenImageState extends State<FullScreenImage> {
  PageController controller;
  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: widget.index);
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
        await SystemChrome.setEnabledSystemUIMode(
          SystemUiMode.manual,
          overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top],
        );
        Navigator.pop(context);
        return true;
      },
      child: AnnotatedRegion(
        value: SystemChrome.setEnabledSystemUIMode(
          SystemUiMode.edgeToEdge,
          // overlays: [],
        ),
        child: AnnotatedRegion(
          value: AppbarUtils.systemUiOverylay(),
          child: Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
              children: [
                PageView.builder(
                  padEnds: true,
                  physics: BouncingScrollPhysics(),
                  controller: controller,
                  itemCount: provider.allPhotos.length,
                  onPageChanged: (int index) {
                    controller.animateToPage(
                      index,
                      duration: duration,
                      curve: curve,
                    );
                  },
                  itemBuilder: (context, index) {
                    final image = widget.files[index];
                    print('index is $index');
                    final interactive = InteractiveViewer(
                      minScale: 1.0,
                      maxScale: 100.0,
                      child: Image.file(
                        image,
                        fit: BoxFit.contain,
                        cacheWidth: 384,
                      ),
                    );

                    return interactive;
                  },
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: Responsive.width(100),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.black26, Colors.transparent],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        button(Icons.delete_outline_rounded, onPressed: () {
                          deletePhoto(controller, widget.files);
                          // ignore: invalid_use_of_protected_member
                          provider.notifyListeners();
                        }),
                        button(Icons.share_rounded),
                        button(Icons.info_outline_rounded),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void deletePhoto(PageController controller, List<File> files) {
  final index = controller.page.toInt();
  files[index].delete();
  files.removeAt(index);
  controller.previousPage(duration: duration, curve: curve);
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
      color: Colors.white,
      size: Responsive.imageSize(6),
    ),
  );
}
