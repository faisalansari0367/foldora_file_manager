import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

List<Widget> animatedListView({@required List<Widget> children}) {
  return AnimationConfiguration.toStaggeredList(
    duration: const Duration(milliseconds: 400),
    childAnimationBuilder: (widget) => SlideAnimation(
      horizontalOffset: 50.0,
      child: FadeInAnimation(
        delay: Duration(milliseconds: 80),
        child: widget,
      ),
    ),
    children: children,
  );
}
