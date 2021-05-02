import 'package:animations/animations.dart';
import 'package:files/provider/StoragePathProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';

import '../../sizeConfig.dart';

class FullScreenImage extends StatelessWidget {
  final int index;
  FullScreenImage({this.index});
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StoragePathProvider>(context, listen: false);

    return Scaffold(
      // backgroundColor: Colors.black,
      body: Container(
        color: Colors.black,
        child: Center(
          child: Selector<StoragePathProvider, int>(
              selector: (_, value) => value.photosIndex,
              builder: (context, value, child) {
                // final image = PhotoView(
                //   imageProvider: AssetImage(provider.imagesPath[value].path),

                // );
                return GestureDetector(
                  onScaleStart: (ScaleStartDetails scaleStart) => print('scaling starts started $scaleStart'),
                  onScaleEnd: (ScaleEndDetails scaleEnd) => print('scaling ends started $scaleEnd'),
                  // onScaleUpdate: ,
                  onHorizontalDragEnd: (e) =>
                      provider.onHorizontalDragEnd(e.primaryVelocity, value),
                  child: PageTransitionSwitcher(
                    duration: Duration(milliseconds: 400),
                    reverse: provider.reverse,
                    // child: image,
                    child: Image.file(
                      provider.imagesPath[value],
                      width: 100 * Responsive.widthMultiplier,
                      fit: BoxFit.contain,
                      key: UniqueKey(),
                      cacheWidth: 1080,
                    ),
                    transitionBuilder: (child, animation, secondaryAnimation) =>
                        SharedAxisTransition(
                      fillColor: Colors.transparent,
                      animation: animation,
                      secondaryAnimation: secondaryAnimation,
                      transitionType: SharedAxisTransitionType.horizontal,
                      child: child,
                      key: UniqueKey(),
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
