import 'package:files/pages/HomePage/HomePage.dart';
import 'package:files/provider/MyProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';

import '../sizeConfig.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  PageController pageController;
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

  static const Duration duration = Duration(milliseconds: 100);
  static const iconPath = 'assets/undraw_app_data_re_vg5c.svg';
  static const iconPath2 = 'assets/undraw_file_manager_j85s.svg';

  void redirectToHome() {
    final pageView = PageView(
      children: [HomePage(), HomePage()],
    );
    final route = MaterialPageRoute(builder: (context) => pageView);
    Navigator.pushReplacement(context, route);
  }

  int _initialPage = 0;

  void _onpressed() async {
    final provider = Provider.of<MyProvider>(context, listen: false);
    final status = await provider.getPermission();

    if (status.isGranted) {
      setFirstSeen();
      Future.delayed(
        duration,
        () {
          pageController.animateToPage(
            1,
            duration: Duration(milliseconds: 350),
            curve: Curves.decelerate,
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
            screen(iconPath2, 'Let"s Explore', redirectToHome)
          ],
        ),
      ),
    );
  }
}

Widget screen(String path, String text, Function onpressed) => Column(
      children: [
        SvgPicture.asset(
          path,
          height: Responsive.height(80),
          // width: Responsive.width(80),
          fit: BoxFit.contain,
        ),
        ElevatedButton(
          onPressed: onpressed,
          child: Text(text),
        )
      ],
    );
