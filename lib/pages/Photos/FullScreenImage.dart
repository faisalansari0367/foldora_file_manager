// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:extended_image/extended_image.dart';
import 'package:files/decoration/my_decoration.dart';
import 'package:files/decoration/my_bottom_sheet.dart';
import 'package:files/provider/storage_path_provider.dart';
import 'package:files/sizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as p;
import 'package:share/share.dart';

import 'options_bottom_sheet.dart';

class FullScreenImage extends StatefulWidget {
  final int index;
  final List<File> files;
  const FullScreenImage({this.index, this.files});

  @override
  _FullScreenImageState createState() => _FullScreenImageState();
}

const duration = Duration(milliseconds: 375);
const curve = Curves.decelerate;

class _FullScreenImageState extends State<FullScreenImage> with SingleTickerProviderStateMixin {
  PageController controller;
  AnimationController _animationController;
  Animation _animation;
  Function() animationListener = () {};

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
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
        // await SystemChrome.setEnabledSystemUIMode(
        //   SystemUiMode.edgeToEdge,
        //   overlays: [],
        // );
        Navigator.pop(context);
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            PageView.builder(
              physics: MyDecoration.physics,
              controller: controller,
              itemCount: provider.allPhotos.length,
              onPageChanged: onPageChanged,
              itemBuilder: (context, index) {
                final image = widget.files[index];
                final extendedImage = ExtendedImage.file(
                  image,
                  mode: ExtendedImageMode.gesture,
                  fit: BoxFit.contain,
                  onDoubleTap: onDoubleTap,
                               
                );
                return extendedImage;
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
                    button(
                      Icons.share_rounded,
                      onPressed: () => Share.shareFiles([widget.files[controller.page.toInt()].path]),
                    ),
                    button(
                      Icons.info_outline_rounded,
                      onPressed: () => showInfo(context, widget.files[controller.page.toInt()]),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void onPageChanged(int index) {
    controller.animateToPage(
      index,
      duration: duration,
      curve: curve,
    );
  }

  void onDoubleTap(ExtendedImageGestureState state) {
    ///you can use define pointerDownPosition as you can,
    ///default value is double tap pointer down postion.
    var pointerDownPosition = state.pointerDownPosition;
    var begin = state.gestureDetails.totalScale;
    double end;

    //remove old
    _animation?.removeListener(animationListener);

    //stop pre
    _animationController.stop();

    //reset to use
    _animationController.reset();
    end = begin == 1 ? 2.5 : 1;

    animationListener = () {
      state.handleDoubleTap(scale: _animation.value, doubleTapPosition: pointerDownPosition);
    };
    final curvedAnimation = CurvedAnimation(parent: _animationController, curve: MyDecoration.curve);
    _animation = Tween<double>(begin: begin, end: end).animate(curvedAnimation);

    _animation.addListener(animationListener);

    _animationController.forward();
  }
}

void showInfo(BuildContext context, File file) {
  final name = p.basenameWithoutExtension(file.path);
  final themeData = ThemeData.dark();
  MyBottomSheet.bottomSheet(
    context,
    child: Theme(
      data: themeData,
      child: OptionsBottomSheet(name: name, file: file),
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
