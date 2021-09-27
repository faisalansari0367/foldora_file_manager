import 'package:files/pages/HomePage/HomePage.dart';
import 'package:files/provider/MyProvider.dart';
import 'package:files/utilities/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';

import '../sizeConfig.dart';

final style = ElevatedButton.styleFrom(
  elevation: 4,
  primary: MyColors.teal,
  shadowColor: MyColors.teal,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(32.0),
    side: BorderSide(color: MyColors.teal),
  ),
  minimumSize: Size(Responsive.width(87), Responsive.height(6)),
);

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  PageController pageController;
  int _initialPage = 0;
  static const Duration duration = Duration(milliseconds: 100);
  static const iconPath = 'assets/undraw_app_data_re_vg5c.svg';
  static const iconPath2 = 'assets/undraw_file_manager_j85s.svg';

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    pageController = PageController(initialPage: _initialPage);
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    pageController = null;
    super.dispose();
  }

  Future<bool> setFirstSeen() async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setBool('firstSeen', true);
  }

  void redirectToHome() {
    final pageView = PageView(
      children: [HomePage(), HomePage()],
    );
    final route = MaterialPageRoute(builder: (context) => pageView);
    Navigator.pushReplacement(context, route);
  }

  Future<void> _onpressed() async {
    final provider = Provider.of<MyProvider>(context, listen: false);
    final status = await provider.getPermission();
    print('storage permission granted: ${status.isGranted}');
    if (status.isGranted) {
      await setFirstSeen();
      Future.delayed(
        duration,
        () {
          pageController.animateToPage(
            1,
            duration: Duration(milliseconds: 500),
            curve: Curves.fastOutSlowIn,
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: PageView(
          onPageChanged: (int page) => _initialPage = page,
          controller: pageController,
          physics: NeverScrollableScrollPhysics(),
          children: [
            screen(iconPath, 'Allow Permission', _onpressed),
            screen(iconPath2, 'Grant Files Access', grantFilesAccess),
            screen(iconPath2, 'Let"s Explore', redirectToHome),
          ],
        ),
      ),
    );
  }

  bool isGranted = false;

  Future<void> grantFilesAccess() async {
    // if ()) {
    //   await StorageSpace.getAllFilesAccessPermission();
    //   isGranted = true;
    //   setState(() {});
    //   print(isGranted);
    // }
    Future.delayed(
      duration,
      () {
        pageController.animateToPage(
          2,
          duration: Duration(milliseconds: 500),
          curve: Curves.fastOutSlowIn,
        );
      },
    );
  }
}

Widget screen(String path, String text, Function onpressed) => Column(
      children: [
        SvgPicture.asset(
          path,
          height: Responsive.height(80),
          // width: Responsive.width(80),
          color: MyColors.teal,
          fit: BoxFit.contain,
        ),
        ElevatedButton(
          onPressed: onpressed,
          style: style,
          child: Text(text),
        )
      ],
    );
