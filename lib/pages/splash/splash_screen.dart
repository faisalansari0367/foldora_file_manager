import 'dart:developer';

import 'package:files/constants/assets/onboard.dart';
import 'package:files/pages/HomePage/HomePage.dart';
import 'package:files/pages/splash/screen.dart';
import 'package:files/services/permission_service.dart';
import 'package:files/services/storage_service.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with WidgetsBindingObserver {
  PageController? pageController;
  int _initialPage = 0;
  static const Duration duration = Duration(milliseconds: 100);

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    pageController = PageController(initialPage: _initialPage);
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    log(state.toString());
    switch (state) {
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
      default:
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    pageController!.dispose();
    pageController = null;
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _moveToPage(int page) async {
    await Future.delayed(duration, () {
      pageController!.animateToPage(
        page,
        duration: Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
      );
    });
  }

  Future<void> setFirstSeen() async => await StorageService().setFirstTimeSeen();

  Future<void> _redirectToHome() async {
    // final status = await PermissionService.accessAllFiles();
    // if (status) {
    final pageView = PageView(children: [HomePage(), HomePage()]);
    final route = MaterialPageRoute(builder: (context) => pageView);
    await Navigator.pushReplacement(context, route);
    // }
  }

  Future<void> _onpressed() async {
    final status = await PermissionService.storage();
    print(status);
    if (status) {
      await setFirstSeen();
      await _moveToPage(1);
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
            buttonText: 'Allow all files access',
            onPressed: _redirectToHome,
            title: Screen.titleWidget('Let\'s', 'Explore'),
          ),
        ],
      ),
    );
  }
}
