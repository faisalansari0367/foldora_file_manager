import 'package:files/provider/StoragePathProvider.dart';
import 'package:files/sizeConfig.dart';
import 'package:files/utilities/MyColors.dart';
import 'package:files/widgets/MyAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class FullScreenImage extends StatefulWidget {
  final int index;
  FullScreenImage({this.index});

  @override
  _FullScreenImageState createState() => _FullScreenImageState();
}

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
    final width = 1080;
    bool fullScreen = true;
    return WillPopScope(
      onWillPop: () async {
        SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom, SystemUiOverlay.top]);
        Navigator.pop(context);
        return true;
      },
      child: AnnotatedRegion(
        value: SystemChrome.setEnabledSystemUIOverlays([]),
        child: AnnotatedRegion(
          value: AppbarUtils.systemUiOverylay(),
          child: Scaffold(
            body: Container(
              color: Colors.black,
              child: Center(
                child: PageView.builder(
                  allowImplicitScrolling: true,
                  physics: BouncingScrollPhysics(),
                  controller: controller,
                  itemCount: provider.imagesPath.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onVerticalDragStart: (_) => dragStart(context, provider.deletePhoto, index),
                      onVerticalDragUpdate: print,
                      onVerticalDragEnd: print,
                      // onVerticalDragDown: (_) => Navigator.pop(context),
                      onTap: () {
                        fullScreen ? resetOverlay() : setOverlay();
                        fullScreen = !fullScreen;
                      },
                      child: Image.file(
                        provider.imagesPath[index],
                        cacheWidth: width,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void dragStart(BuildContext context, Function deletePhoto, int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          color: MyColors.darkGrey,
          height: Responsive.height(6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              button(
                Icons.delete,
                onPressed: () {
                  controller.animateToPage(
                    index++,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeIn,
                  );
                  Future.delayed(Duration.zero, () {
                    deletePhoto(index);
                  });
                },
              ),
              button(Icons.info),
              button(Icons.share),
              // button(iconData)
            ],
          ),
        );
      },
    );
  }
}

void setOverlay() {
  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom, SystemUiOverlay.top]);
}

void resetOverlay() {
  SystemChrome.setEnabledSystemUIOverlays([]);
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
