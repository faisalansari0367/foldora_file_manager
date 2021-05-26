import 'dart:math';

import 'package:files/sizeConfig.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_circular_chart/flutter_circular_chart.dart';

class CircleChart extends StatefulWidget {
  final double percentage;
  final double radius;
  final Color color;
  final double strokeWidth;
  final Duration duration;

  const CircleChart({
    this.percentage,
    this.radius,
    this.color,
    this.strokeWidth,
    this.duration,
  });
  @override
  _CircleChartState createState() => _CircleChartState();
}

class _CircleChartState extends State<CircleChart>
    with TickerProviderStateMixin {
  AnimationController _controller;
  static const duration = const Duration(milliseconds: 1000);
  var percentage = 0.0;
  void createAnimation(AnimationController controller) {
    final curved =
        CurvedAnimation(parent: controller, curve: Curves.easeInOutBack);
    final tween = Tween<double>(begin: 0, end: widget.percentage);
    final animationValue = tween.animate(curved);
    animationValue.addListener(() {
      setState(() {
        percentage = animationValue.value;
      });
    });
  }

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration ?? duration,
    );

    createAnimation(_controller);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward(); // Start the animation when widget is displayed
    });
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CircleChart oldWidget) {
    print('widget update');
    createAnimation(_controller);
    _controller.forward();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.removeListener(() {});
    _controller.dispose();
    _controller = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Responsive.imageSize(5);
    return CustomPaint(
      willChange: true,
      key: UniqueKey(),
      size: Size(size, size),
      painter: MyPainter(
        strokeWidth: widget.strokeWidth,
        color: widget.color,
        radius: Responsive.imageSize(widget.radius),
        percentage: percentage,
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  final double radius;
  final Color color;
  final double percentage;
  final double strokeWidth;

  MyPainter({
    this.strokeWidth = 5,
    this.percentage,
    this.color,
    this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    var backGroundCircle = Paint()
      ..color = Colors.grey[100]
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Offset center = Offset(size.width / 2, size.height / 2);
    double arcAngle = 2 * pi * percentage / 100;
    canvas.drawCircle(center, radius, backGroundCircle);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      arcAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
