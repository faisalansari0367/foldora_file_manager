import 'package:files/decoration/my_decoration.dart';
import 'package:files/widgets/animated_widgets/animated_button.dart';
import 'package:flutter/material.dart';

import '../../../sizeConfig.dart';

class MediaStack extends StatelessWidget {
  final String? image;
  final Color? color;
  final String? media;
  final String? items;
  final String? privacy;
  final Color? shadow;
  final Icon? lock;
  final String? size;
  final void Function()? onTap;

  const MediaStack({
    this.image,
    this.color,
    this.media,
    this.items,
    this.privacy,
    this.shadow,
    this.lock,
    this.size,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedButton(
      onTap: onTap,
      child: Stack(
        children: <Widget>[
          Opacity(
            opacity: 0.9,
            child: Container(
              height: 40 * Responsive.heightMultiplier,
              width: 55 * Responsive.widthMultiplier,
              decoration: BoxDecoration(
                color: color,
                borderRadius: MyDecoration.borderRadius,
              ),
            ),
          ),
          Positioned(
            top: 5 * Responsive.heightMultiplier,
            left: 6 * Responsive.widthMultiplier,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: shadow!,
                    offset: Offset(2.0, 5.0),
                    blurRadius: 10.0,
                  ),
                ],
              ),
              child: Opacity(
                opacity: 0.6,
                child: Image.asset(
                  image!,
                  height: 12 * Responsive.imageSizeMultiplier,
                ),
                // child: Icon(
                //   Icons.photo,
                //   color: Colors.teal[300],
                //   size: 12 * Responsive.imageSizeMultiplier,
                // ),
              ),
            ),
          ),
          Positioned(
            top: 22 * Responsive.heightMultiplier,
            left: 6 * Responsive.widthMultiplier,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  media!,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[800],
                    fontSize: 3.4 * Responsive.textMultiplier,
                  ),
                ),
                SizedBox(
                  height: 1 * Responsive.heightMultiplier,
                ),
                Text(
                  items!,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[700],
                    fontSize: 2.2 * Responsive.textMultiplier,
                  ),
                ),
                SizedBox(
                  height: 2 * Responsive.heightMultiplier,
                ),
              ],
            ),
          ),
          Positioned(
            top: 32 * Responsive.heightMultiplier,
            left: 2 * Responsive.widthMultiplier,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 4 * Responsive.widthMultiplier),
                  child: lock,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15 * Responsive.widthMultiplier),
                  child: Text(
                    size!,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[700],
                      fontSize: 2.2 * Responsive.textMultiplier,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// class AnimatedText extends StatefulWidget {
//   const AnimatedText({Key key}) : super(key: key);

//   @override
//   _AnimatedTextState createState() => _AnimatedTextState();
// }

// class _AnimatedTextState extends State<AnimatedText> with SingleTickerProviderStateMixin {
//   AnimationController controller;
//   Tween<double> tween;
//   Animation<double> animation;
//   @override
//   void initState() {
//     controller = AnimationController(vsync: this, duration: Duration(seconds: 10));
//     tween = Tween<double>(begin: 0.0, end: 1000);
//     final curvedAnimation = CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);
//     animation = tween.animate(curvedAnimation);
//     controller.forward();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   // last number will change
//   // string.last
//   // second last number changed
//   // 101 and 100
//   // number changed last one how can i get that

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: animation,
//       builder: (BuildContext context, Widget child) {
//         return Text(animation.value.toStringAsFixed(2));
//       },
//     );
//   }
// }

// // class AnimatedCount extends ImplicitlyAnimatedWidget {
// //   AnimatedCount({
// //     Key key,
// //     @required this.count,
// //     @required Duration duration,
// //     Curve curve = Curves.linear,
// //   }) : super(duration: duration, curve: curve, key: key);

// //   final num count;

// //   @override
// //   ImplicitlyAnimatedWidgetState<ImplicitlyAnimatedWidget> createState() {
// //     return _AnimatedCountState();
// //   }
// // }

// // class _AnimatedCountState extends AnimatedWidgetBaseState<AnimatedCount> {
// //   IntTween _intCount;
// //   Tween<double> _doubleCount;

// //   @override
// //   Widget build(BuildContext context) {
// //     return widget.count is int
// //         ? Text(_intCount.evaluate(animation).toString())
// //         : Text(_doubleCount.evaluate(animation).toStringAsFixed(1));
// //   }

// //   @override
// //   void forEachTween(TweenVisitor visitor) {
// //     if (widget.count is int) {
// //       _intCount = visitor(
// //         _intCount,
// //         widget.count,
// //         (dynamic value) => IntTween(begin: value),
// //       );
// //     } else {
// //       _doubleCount = visitor(
// //         _doubleCount,
// //         widget.count,
// //         (dynamic value) => Tween<double>(begin: value),
// //       );
// //     }
// //   }
// // }
