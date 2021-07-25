import 'package:files/widgets/BottomAnimation.dart';
import 'package:flutter/material.dart';

class AnimatedButton extends StatefulWidget {
  final Widget child;
  final Function onTap;
  const AnimatedButton({
    @required this.child,
    this.onTap,
  });

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _scale;
  static const duration = Duration(milliseconds: 200);
  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: duration);
    // _scale = TweenSequence(
    //   [
    //     TweenSequenceItem<double>(
    //       tween: Tween<double>(begin: 1.0, end: 0.95).chain(CurveTween(curve: Curves.ease)),
    //       weight: 20.0,
    //     ),
    //     TweenSequenceItem<double>(
    //       tween: Tween<double>(begin: 0.95, end: 1.0).chain(CurveTween(curve: Curves.ease)),
    //       weight: 40.0,
    //     ),
    //   ],
    // ).animate(_controller);

    _scale = Tween<double>(begin: 1.0, end: 0.95)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.bounceInOut));

    // _controller.forward();
    // ..addListener(() => setState(() {}))
    super.initState();
  }

  @override
  void dispose() {
    _scale = null;
    _controller.dispose();
    _controller = null;
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: UniqueKey(),
      onTap: widget.onTap,
      onTapUp: _onTapUp,
      onTapDown: _onTapDown,
      // onTap: () {
      //   _controller.forward();
      //   // Future.delayed(duration, () => widget.onTap());
      //   // widget.onTap();
      // },
      child: AnimatedBuilder(
        animation: _controller,
        child: widget.child,
        builder: (BuildContext context, Widget child) {
          return Transform.scale(
            scale: _scale.value,
            child: child,
          );
        },
      ),
    );
  }
}
