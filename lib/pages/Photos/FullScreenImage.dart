// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:io';

import 'package:files/decoration/my_decoration.dart';
import 'package:files/helpers/date_format_helper.dart';
import 'package:files/pages/Drive/my_bottom_sheet.dart';
import 'package:files/pages/Photos/options_row.dart';
import 'package:files/provider/storage_path_provider.dart';
import 'package:files/sizeConfig.dart';
import 'package:files/utilities/Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as p;

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
          SystemUiMode.immersive,
          overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top],
        ),
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
                  return InteractiveViewer(
                    minScale: 1.0,
                    maxScale: 100.0,
                    child: Image.file(
                      image,
                      fit: BoxFit.contain,
                      // cacheWidth: 384,
                    ),
                  );
                },
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(2.padding),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.black26, Colors.transparent],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      button(Icons.delete_outline_rounded, onPressed: () {
                        deletePhoto(controller, widget.files);
                        // ignore: invalid_use_of_protected_member
                        provider.notifyListeners();
                      }),
                      button(Icons.share_rounded),
                      button(Icons.info_outline_rounded,
                          onPressed: () => showInfo(context, widget.files[controller.page.toInt()])),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

void showInfo(BuildContext context, File file) {
  final name = p.basenameWithoutExtension(file.path);
  final stat = file.statSync();
  final themeData = ThemeData.dark();
  MyBottomSheet.bottomSheet(
    context,
    child: Theme(
      data: themeData,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          MyDecoration.bottomSheetTopIndicator(
            heightFactor: 1.height,
            color: Colors.grey,
          ),
          SizedBox(height: 1.height),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.padding),
            child: OptionsRow(file: file),
          ),
          SizedBox(height: 1.height),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.image,
              size: 10.image,
            ),
            title: Text(name),
            subtitle: Text(FileUtils.formatBytes(file.statSync().size, 2)),
          ),
          SizedBox(height: 1.height),
          ListTile(
            title: Text(DateFormatter.formatDateInDMY(stat.modified)),
          ),
          SizedBox(height: 2.height),
        ],
      ),
    ),
  );
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
