import 'dart:math';

import 'package:flutter/material.dart';

// import 'package:flutter_circular_chart/flutter_circular_chart.dart';

class RoundedProgressIndicator extends StatefulWidget {
  final double percentage;
  final double radius;
  final Color color;
  final Color backgroundColor;
  final double strokeWidth;
  final Duration duration;
  final Curve curve;

  const RoundedProgressIndicator({
    Key key,
    @required this.percentage,
    @required this.radius,
    @required this.color,
    @required this.strokeWidth,
    this.backgroundColor,
    this.curve = Curves.easeInOutBack,
    this.duration = const Duration(milliseconds: 1000),
  }) : super(key: key);

  @override
  _RoundedProgressIndicatorState createState() => _RoundedProgressIndicatorState();
}

class _RoundedProgressIndicatorState extends State<RoundedProgressIndicator> with SingleTickerProviderStateMixin {
  Tween<double> tween = Tween<double>(begin: 0.0, end: 0.0);

  void createAnimation({double begin = 0.0}) {
    tween = Tween<double>(begin: begin, end: widget.percentage);
  }

  @override
  void didUpdateWidget(covariant RoundedProgressIndicator oldWidget) {
    updateWidget(oldWidget);
    super.didUpdateWidget(oldWidget);
  }

  void updateWidget(RoundedProgressIndicator oldWidget) {
    if (widget.percentage != oldWidget.percentage) {
      createAnimation(begin: oldWidget.percentage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      curve: widget.curve,
      duration: widget.duration,
      tween: tween,
      builder: (context, double value, child) {
        return CustomPaint(
          painter: MyPainter(
            backgroundColor: widget.backgroundColor ?? Colors.grey.shade100,
            strokeWidth: widget.strokeWidth,
            color: widget.color,
            radius: widget.radius,
            percentage: value,
          ),
        );
      },
    );
  }
}

class MyPainter extends CustomPainter {
  final double radius;
  final Color color, backgroundColor;
  final double percentage;
  final double strokeWidth;

  MyPainter({
    this.strokeWidth = 5,
    @required this.percentage,
    @required this.color,
    @required this.backgroundColor,
    @required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final backGroundCircle = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final arcAngle = 2 * pi * percentage / 100;
    canvas.drawCircle(center, radius, backGroundCircle);
    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(rect, -pi / 2, arcAngle, false, paint);
  }

  @override
  bool shouldRepaint(covariant MyPainter oldDelegate) => oldDelegate.percentage != percentage;
}
