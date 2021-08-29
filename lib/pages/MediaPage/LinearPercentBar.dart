import 'package:files/provider/MyProvider.dart';
import 'package:files/sizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

class LinearPercentBar extends StatelessWidget {
  // final Storage storage;
  const LinearPercentBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MyProvider>(context, listen: true),
        storage = provider.spaceInfo[provider.currentPage],
        calculatePercent = storage.used / storage.total * 100;

    final Widget child = Padding(
      padding: EdgeInsets.only(
        right: 6 * Responsive.imageSizeMultiplier,
        left: 6 * Responsive.imageSizeMultiplier,
        top: 10 * Responsive.imageSizeMultiplier,
      ),
      child: Center(
        child: LinearPercentIndicator(
          animation: true,
          curve: Curves.easeInOutBack,
          animationDuration: 1000,
          // restartAnimation: false,

          // restartAnimation: true,
          animateFromLastPercent: true,
          width: 0.87 * MediaQuery.of(context).size.width,
          lineHeight: 8.0,
          percent: calculatePercent / 100,
          progressColor: Colors.greenAccent,
          backgroundColor: Colors.grey[700],
        ),
      ),
    );

    return child;
  }
}

// class StoragePercent extends StatefulWidget {
//   const StoragePercent({Key key}) : super(key: key);

//   @override
//   StoragePercentState createState() => StoragePercentState();
// }

// class StoragePercentState extends State<StoragePercent> {
//   @override
//   Widget build(BuildContext context) {
//     return CustomPaint(
//       painter: LinePainter(),
//     );
//   }
// }

// class LinePainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//       // TODO: implement paint
//     }

//     @override
//     bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     // TODO: implement shouldRepaint
//     throw UnimplementedError();
//   }
// }
