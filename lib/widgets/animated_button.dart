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

  static const duration = Duration(milliseconds: 300);

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: duration);
    final animation = CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn);
    _scale = Tween<double>(begin: 1.0, end: 0.95).animate(animation);
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
