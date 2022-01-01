import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

List<Widget> animatedListView({@required List<Widget> children}) {
  final curve = Curves.fastOutSlowIn;
  return AnimationConfiguration.toStaggeredList(
    duration: const Duration(milliseconds: 1000),
    childAnimationBuilder: (widget) => SlideAnimation(
      horizontalOffset: 30.0,
      // verticalOffset: 30.0,
      curve: curve,
      child: FadeInAnimation(
        curve: curve,
        delay: Duration(milliseconds: 80),
        child: widget,
      ),
    ),
    children: children,
  );
}
