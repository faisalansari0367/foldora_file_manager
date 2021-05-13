import 'package:files/pages/HomePage/HomePage.dart';
import 'package:files/provider/LeadingIconProvider.dart';
import 'package:files/provider/OperationsProvider.dart';
import 'package:files/provider/StoragePathProvider.dart';
import 'package:files/provider/MyProvider.dart';
import 'package:files/sizeConfig.dart';
import 'package:files/utilities/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

// This widget is the root of your application.

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void systemOverlay() {
    SystemChrome.setEnabledSystemUIOverlays(
      [SystemUiOverlay.top, SystemUiOverlay.bottom],
    );
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // SystemChrome.setSystemUIOverlayStyle(
    // SystemUiOverlayStyle(statusBarColor: Color(0xff2c2c3c)));
  }

  // bool isSeenAlready = false;
  Future<bool> isFirstTimeAppOpen() async {
    // isSeenAlready = await Permission.storage.isGranted;
    return await Permission.storage.isGranted;
  }

  @override
  void initState() {
    // isFirstTimeAppOpen();
    // WidgetsFlutterBinding.ensureInitialized();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final PageView pageView = PageView(
      children: [HomePage(), HomePage()],
    );
    // isFirstTimeAppOpen();

    final futureBuilder = FutureBuilder(
      future: isFirstTimeAppOpen(),
      initialData: false,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return snapshot.data ? pageView : SplashScreen();
      },
    );

    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        Responsive().init(constraints, orientation);
        return MultiProvider(
          providers: [
            ChangeNotifierProvider<MyProvider>(
                create: (context) => MyProvider()),
            ChangeNotifierProvider<StoragePathProvider>(
                create: (context) => StoragePathProvider()),
            ChangeNotifierProvider<IconProvider>(
                create: (context) => IconProvider()),
            ChangeNotifierProvider<Operations>(
                create: (context) => Operations()),
          ],
          child: MaterialApp(
            theme: MyColors.themeData,
            showPerformanceOverlay: false,
            debugShowCheckedModeBanner: false,
            title: 'Files App',
            // home: isSeenAlready ? pageView : SplashScreen(),
            home: futureBuilder,
          ),
        );
      });
    });
  }
}

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

  static const Duration duration = Duration(milliseconds: 100);
  final iconPath = 'assets/undraw_app_data_re_vg5c.svg';
  final iconPath2 = 'assets/undraw_file_manager_j85s.svg';

  void redirectToHome() {
    final pageView = PageView(children: [HomePage(), HomePage()]);
    final route = MaterialPageRoute(builder: (context) => pageView);
    Navigator.push(context, route);
  }

  int _initialPage = 0;

  void _onpressed() async {
    final provider = Provider.of<MyProvider>(context, listen: false);
    var status = await provider.getPermission();
    if (status.isGranted) {
      Future.delayed(duration, () {
        pageController.animateToPage(1,
            duration: Duration(milliseconds: 350), curve: Curves.decelerate);
        // setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget screen(String path, String text, Function onpressed) => Container(
          height: MediaQuery.of(context).size.height,
          // color: Colors.grey,
          child: Column(
            children: [
              SvgPicture.asset(
                path,
                fit: BoxFit.contain,
              ),
              ElevatedButton(
                onPressed: onpressed,
                child: Text(text),
              )
            ],
          ),
        );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: PageView(
          onPageChanged: (int page) => _initialPage = page,
          controller: pageController,
          children: [
            screen(iconPath, 'Allow Permission', _onpressed),
            screen(iconPath2, 'Let"s Explore', redirectToHome)
          ],
        ),
      ),
    );
  }
}
