import 'package:files/decoration/my_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class MySlideAnimation extends StatelessWidget {
  final Widget child;
  final Curve curve;
  final double verticalOffset, horizontalOffset;
  final int delayInMs;

  const MySlideAnimation({
    Key key,
    @required this.child,
    this.curve = Curves.easeInOutExpo,
    this.verticalOffset = 50.0,
    this.horizontalOffset = 0.0,
    this.delayInMs = 100,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.synchronized(
      duration: MyDecoration.duration,
      child: SlideAnimation(
        verticalOffset: verticalOffset,
        horizontalOffset: horizontalOffset,
        child: FadeInAnimation(
          delay: Duration(milliseconds: delayInMs),
          curve: curve,
          child: child,
        ),
      ),
    );
  }
}
