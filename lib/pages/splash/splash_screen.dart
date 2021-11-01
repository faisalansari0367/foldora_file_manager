import 'package:files/constants/assets/onboard.dart';
import 'package:files/pages/HomePage/HomePage.dart';
import 'package:files/pages/splash/screen.dart';
import 'package:files/provider/MyProvider.dart';
import 'package:files/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';




class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  PageController pageController;
  int _initialPage = 0;
  static const Duration duration = Duration(milliseconds: 100);

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

  Future<void> moveToPage(int page) async {
    void _listener() {
      pageController.animateToPage(
        page,
        duration: Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
      );
    }

    await Future.delayed(duration, _listener);
  }

  Future<void> setFirstSeen() async {
    final storage = StorageService();
    await storage.setFirstTimeSeen();
  }

  void redirectToHome() {
    final pageView = PageView(children: [HomePage(), HomePage()]);
    final route = MaterialPageRoute(builder: (context) => pageView);
    Navigator.pushReplacement(context, route);
  }

  Future<void> _onpressed() async {
    final provider = Provider.of<MyProvider>(context, listen: false);
    final status = await provider.getPermission();
    print(status.isGranted);
    if (status.isGranted) {
      await setFirstSeen();
      await moveToPage(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        scrollDirection: Axis.horizontal,
        onPageChanged: (int page) => _initialPage = page,
        controller: pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          Screen(
            path: Onboard.undraw1,
            buttonText: 'Allow Permission',
            onPressed: _onpressed,
            title: Screen.titleWidget('Welcome to', 'Foldora'),
          ),
          Screen(
            path: Onboard.undraw4,
            buttonText: 'Let"s Explore',
            onPressed: redirectToHome,
            title: Screen.titleWidget('Let\'s', 'Explore'),
          ),
        ],
      ),
    );
  }
}
