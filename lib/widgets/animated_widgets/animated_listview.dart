import 'package:files/decoration/my_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

List<Widget> animatedListView({required List<Widget> children}) {
  return AnimationConfiguration.toStaggeredList(
    duration: MyDecoration.duration,
    childAnimationBuilder: (widget) => SlideAnimation(
      // horizontalOffset: 30.0,
      verticalOffset: 30.0,
      curve: MyDecoration.curve,
      child: FadeInAnimation(
        curve: MyDecoration.curve,
        delay: Duration(milliseconds: 80),
        // delay: MyDecoration.duration,
        child: widget,
      ),
    ),
    children: children,
  );
}
