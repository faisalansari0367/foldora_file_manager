// import 'dart:io';

// import 'package:files/provider/StoragePathProvider.dart';
// import 'package:files/sizeConfig.dart';
// import 'package:files/utilities/MyColors.dart';
// import 'package:files/widgets/delete_modal.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// const duration = Duration(milliseconds: 500);

// class BottomSlideAnimation extends StatefulWidget {
//   final Widget child;
//   const BottomSlideAnimation({Key key, this.child}) : super(key: key);

//   // static AnimationController controller;
//   @override
//   _BottomSlideAnimationState createState() => _BottomSlideAnimationState();
// }

// class _BottomSlideAnimationState extends State<BottomSlideAnimation>
//     with SingleTickerProviderStateMixin {
//   AnimationController controller;
//   Animation<Offset> slide;

//   @override
//   void initState() {
//     controller = AnimationController(vsync: this, duration: duration);
//     slide = Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset(0.0, 0.0)).animate(controller);
//     // controller.forward();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final storage = Provider.of<StoragePathProvider>(context, listen: false);
//     final myChild = Container(
//       height: Responsive.height(6),
//       color: MyColors.darkGrey,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           IconButton(
//             onPressed: () {
//               final list = <File>[];
//               for (final item in storage.selectedPhotos) {
//                 // list.add(storage.imagesPath[item]);
//                 print(item);
//               }
//               print(list);
//               deleteModal(
//                 context: context,
//                 list: list,
//                 onPressed: () {
//                   storage.deletePhotos(list);
//                   for (final item in list) {
//                     storage.imagesPath.remove(item);
//                   }
//                   storage.selectedPhotos.clear();
//                   Navigator.pop(context);
//                 },
//               );
//             },
//             icon: Icon(Icons.delete),
//             color: MyColors.appbarActionsColor,
//             splashColor: MyColors.whitish,
//           ),
//           IconButton(
//             onPressed: () {},
//             icon: Icon(
//               Icons.share,
//               color: MyColors.appbarActionsColor,
//             ),
//           ),
//         ],
//       ),
//     );
//     return AnimatedBuilder(
//       animation: controller,
//       builder: (context, child) {
//         final provider = Provider.of<StoragePathProvider>(context, listen: true);
//         print('bottom navbar ${provider.hasBottomNav}');
//         provider.hasBottomNav ? controller.forward() : controller.reverse();
//         return SlideTransition(
//           position: slide,
//           child: child,
//         );
//       },
//       child: myChild,
//     );
//   }
// }
