import 'package:files/decoration/my_decoration.dart';
import 'package:files/sizeConfig.dart';
import 'package:files/utilities/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerAnimation extends StatelessWidget {
  final double width, height;
  const ShimmerAnimation({Key key, this.width, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final imageBgColor = theme.cardColor;
    final color = MyColors.darkGrey.withOpacity(0.3);
    final shimmer = Container(
      width: width ?? 100.width,
      height: height ?? 4.image,
      decoration: MyDecoration.decoration(color: color),
    );
    final placeHolder = Shimmer.fromColors(
      highlightColor: color,
      baseColor: Colors.grey[500],
      direction: ShimmerDirection.ltr,
      child: shimmer,
    );
    return placeHolder;
  }
}
