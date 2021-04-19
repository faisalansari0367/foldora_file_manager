import 'package:files/pages/HomePage/widgets/HorizontalTabs.dart';
import 'package:files/pages/HomePage/widgets/circleChartAndFilePercent.dart';
import 'package:files/provider/StoragePathProvider.dart';
import 'package:files/widgets/FloatingActionButton.dart';
import 'package:files/widgets/MyAppBar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../sizeConfig.dart';

// import 'package:files/pages/HomePage/widgets/LatestFiles.dart';
// import 'package:files/widgets/MediaListItem.dart';
// import 'package:files/widgets/StreamBuilder.dart';

/* implement todo

*  to get icons of the apk files.....// this is done
   done making the function but todo how to show these icons correctly.
   showing them correctly there is a lag on scrolling...and need to fix this. 
   

*  to make options to sort files, copy, paste, cut, and delete....still remaining

*  to make navigation bar...this is what i need to implement

*  to make SliverAppBar  //....not necessary until now

*  to make recent files as expected...

*  to make floating action button working..

*  to make thumbnails correctly...thumbnails are good and working correctly 
   but need to change the path of video thumbnails


* i think we dont need to create thumbnail because i can use 
* imageCache but the problem is aspect ratio.....removing height solves this issue for now


*  to use CircleChart with Consumer because
  its not rebuilding when data changes...this is to fix...//this is fixed ✌

*  NOW THE PROBLEM IS....AFTER GIVING THE PERMISSION STORAGE_PATH_PROVIDER CONSTRUCTOR NOT CALLING


*  load images faster..fixed kinda.

IF THERE IS NO ANIMATION WHAT IS IT YOURE GOING TO MAKE SMOOTHER 😂

*  make animations smoother..
*  reduce function calls.. /// this is also good at this point
*  reduce jank..

* stuck at how to show icons according to file type... THIS IS WORKING GOOD AT THIS POINT
  BUT NEED TO OPTIMISE ..BECAUSE SCROLLING IS NOT SMOOTH
* 

*  
 */

class HomePage extends StatelessWidget {
  // double sizing;
  Future<void> _onRefresh(context) async {
    await Provider.of<StoragePathProvider>(context, listen: false).onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    // final provider = Provider.of<StoragePathProvider>(context, listen: false);
    final consumer = Consumer<StoragePathProvider>(builder: (_, value, __) {
      return CircleChartAndFilePercent();
    });

    return Scaffold(
      floatingActionButton: FAB(),
      appBar: MyAppBar(
        backgroundColor: Colors.white,
        iconData: Icons.menu,
        bottomNavBar: false,
        // menu: false,
      ),
      body: Container(
        color: Colors.white,
        child: RefreshIndicator(
          onRefresh: () => _onRefresh(context),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  // top: 6 * Responsive.imageSizeMultiplier,
                  // left: 6 * Responsive.imageSizeMultiplier,
                  left: 6 * Responsive.widthMultiplier,
                  right: 6 * Responsive.imageSizeMultiplier,
                ),
                child: bigText(
                  title: "My Files",
                  color: Colors.grey[500],
                  height: 6,
                  // iconName: Icons.more_horiz,
                ),
              ),
              SizedBox(height: 4 * Responsive.heightMultiplier),
              // CircleChartAndFilePercent(),
              consumer,
              SizedBox(height: 4 * Responsive.heightMultiplier),
              HorizontalTabs(),
              SizedBox(height: 4 * Responsive.heightMultiplier),
              Padding(
                padding: EdgeInsets.only(
                  right: 6 * Responsive.widthMultiplier,
                  left: 6 * Responsive.widthMultiplier,
                  bottom: 2 * Responsive.heightMultiplier,
                ),
                child: bigText(
                  height: 1,
                  title: "Latest Files",
                  iconName: Icons.more_horiz,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget bigText({height, title, iconName, color}) {
  return Row(
    children: <Widget>[
      SizedBox(
        height: height * Responsive.heightMultiplier,
      ),
      Text(
        title,
        style: TextStyle(fontSize: 3.4 * Responsive.textMultiplier),
      ),
      Spacer(),
      iconName != null
          ? Icon(
              Icons.more_horiz,
              size: 6 * Responsive.imageSizeMultiplier,
              color: color,
            )
          : Container(height: 0, width: 0),
    ],
  );
}
