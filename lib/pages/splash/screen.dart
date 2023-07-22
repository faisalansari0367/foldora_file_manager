import 'package:files/utilities/MyColors.dart';
import 'package:files/widgets/animated_widgets/animated_listview.dart';
import 'package:files/widgets/my_annotated_region.dart';
import 'package:files/widgets/my_elevated_button.dart';
import 'package:files/widgets/my_image.dart';
import 'package:flutter/material.dart';

import '../../sizeConfig.dart';

class Screen extends StatefulWidget {
  final String? path, buttonText;
  final Function? onPressed;
  final Widget? title;
  final bool showLoader;

  const Screen({Key? key, this.path, this.onPressed, this.buttonText, this.title, this.showLoader = false})
      : super(key: key);

  @override
  State<Screen> createState() => _ScreenState();

  static Widget titleWidget(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 30),
        ),
        SizedBox(height: Responsive.height(1)),
        Text(
          subtitle,
          style: TextStyle(fontSize: 35, color: MyColors.darkGrey),
        ),
      ],
    );
  }
}

class _ScreenState extends State<Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: MyAnnotatedRegion(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: Responsive.width(5)),
          height: Responsive.height(100),
          // width: Responsive.width(90),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: animatedListView(
                children: [
                  SizedBox(height: Responsive.height(10)),
                  if (widget.title != null) widget.title!,
                  SizedBox(height: Responsive.height(10)),
                  Center(
                    child: MyImage.asset(
                      widget.path!,
                      width: Responsive.width(80),
                      height: Responsive.height(30),
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: Responsive.height(25)),
                  Row(
                    children: [
                      MyElevatedButton(
                        onPressed: widget.onPressed as void Function()?,
                        text: (widget.buttonText),
                        icon: widget.showLoader
                            ? SizedBox(
                                height: 3.5.padding,
                                width: 3.5.padding,
                                child: CircularProgressIndicator(
                                  color: MyColors.white,
                                  // backgroundColor: MyColors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : SizedBox.shrink(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
