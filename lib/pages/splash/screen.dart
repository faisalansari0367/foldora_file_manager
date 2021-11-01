import 'package:files/utilities/MyColors.dart';
import 'package:files/widgets/MyAppBar.dart';
import 'package:files/widgets/animated_listview.dart';
import 'package:files/widgets/my_elevated_button.dart';
import 'package:files/widgets/my_image.dart';
import 'package:flutter/material.dart';

import '../../sizeConfig.dart';

class Screen extends StatefulWidget {
  final String path, buttonText;
  final Function onPressed;
  final Widget title;

  const Screen({Key key, this.path, this.onPressed, this.buttonText, this.title}) : super(key: key);

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
      body: AnnotatedRegion(
        value: AppbarUtils.systemUiOverylay(brightness: Brightness.dark, systemNavigationBarColor: Colors.white),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: Responsive.width(5)),
          height: Responsive.height(100),
          // width: Responsive.width(90),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: animatedListView(
              children: [
                SizedBox(height: Responsive.height(10)),
                if (widget.title != null) widget.title,
                SizedBox(height: Responsive.height(10)),
                Center(
                  child: MyImage.asset(
                    widget.path,
                    width: Responsive.width(80),
                    height: Responsive.height(30),
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: Responsive.height(25)),
                MyElevatedButton(
                  onPressed: widget.onPressed,
                  text: (widget.buttonText),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
