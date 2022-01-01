// import 'dart:io';
// import 'dart:math';

// import 'package:flutter/material.dart';

// var cardAspectRatio = 12.0 / 16.0;
// var widgetAspectRatio = cardAspectRatio * 1.2;
// // var currentPage;
// var padding = 20.0;
// var verticalInset = 20.0;

// class CardScrollWidget extends StatefulWidget {
//   final List<String> images;
//   // final String title;
//   final int currentPage;

//   CardScrollWidget(this.currentPage, this.images);

//   @override
//   State<CardScrollWidget> createState() => _CardScrollWidgetState();
// }

// class _CardScrollWidgetState extends State<CardScrollWidget> {
//   PageController controller;
//   double currentPage = 0;
//   @override
//   void initState() {
//     super.initState();
//     currentPage = widget.images.length - 1.0;
//     controller = PageController(initialPage: widget.images.length - 1);
//     controller.addListener(() {
//       setState(() {
//         currentPage = controller.page;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AspectRatio(
//       aspectRatio: widgetAspectRatio,
//       child: LayoutBuilder(
//         builder: (context, contraints) {
//           var width = contraints.maxWidth;
//           var height = contraints.maxHeight;

//           var safeWidth = width - 2 * padding;
//           var safeHeight = height - 2 * padding;

//           var heightOfPrimaryCard = safeHeight;
//           var widthOfPrimaryCard = heightOfPrimaryCard * cardAspectRatio;

//           var primaryCardLeft = safeWidth - widthOfPrimaryCard;
//           var horizontalInset = primaryCardLeft / 2;

//           // List<Widget> cardList = [];

//           // for (var i = 0; i < widget.images.length; i++) {
//           //   var delta = i - currentPage;
//           //   bool isOnRight = delta > 0;

//           //   var start = padding +
//           //       max(primaryCardLeft - horizontalInset * -delta * (isOnRight ? 15 : 1), 0.0);

//           //   // cardList.add(cardItem);
//           // }
//           return PageView.builder(
//             controller: controller,
//             itemCount: widget.images.length,
//             itemBuilder: (context, i) {
//               var delta = i - currentPage;
//               var isOnRight = delta > 0;
//               var start = padding + max(primaryCardLeft - horizontalInset * -delta * (isOnRight ? 15 : 1), 0.0);
//               return Stack(
//                 children: [
//                   positionedDirectional(widget.images[i], delta, start),
//                 ],
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// Widget positionedDirectional(String path, delta, start) {
//   return Positioned.directional(
//     top: padding + verticalInset * max(-delta, 0.0),
//     bottom: padding + verticalInset * max(-delta, 0.0),
//     start: start,
//     textDirection: TextDirection.rtl,
//     child: ClipRRect(
//       borderRadius: BorderRadius.circular(16.0),
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           boxShadow: [BoxShadow(color: Colors.black12, offset: Offset(3.0, 6.0), blurRadius: 10.0)],
//         ),
//         child: AspectRatio(
//           aspectRatio: cardAspectRatio,
//           child: Stack(
//             fit: StackFit.expand,
//             children: <Widget>[
//               Image.file(File(path), fit: BoxFit.cover),
//               Align(
//                 alignment: Alignment.bottomLeft,
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//                       child: Text(
//                         'title',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 25.0,
//                           fontFamily: 'SF-Pro-Text-Regular',
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 10.0,
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 12.0, bottom: 12.0),
//                       child: Container(
//                         padding: EdgeInsets.symmetric(horizontal: 22.0, vertical: 6.0),
//                         decoration: BoxDecoration(
//                           color: Colors.blueAccent,
//                           borderRadius: BorderRadius.circular(20.0),
//                         ),
//                         child: Text('Read Later', style: TextStyle(color: Colors.white)),
//                       ),
//                     )
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     ),
//   );
// }
