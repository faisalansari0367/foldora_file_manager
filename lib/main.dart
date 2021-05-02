import 'package:files/pages/HomePage/HomePage.dart';
import 'package:files/provider/LeadingIconProvider.dart';
import 'package:files/provider/OperationsProvider.dart';
import 'package:files/provider/StoragePathProvider.dart';
import 'package:files/provider/MyProvider.dart';
import 'package:files/sizeConfig.dart';
import 'package:files/utilities/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

// This widget is the root of your application.

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(
      [SystemUiOverlay.top, SystemUiOverlay.bottom],
    );
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // SystemChrome.setSystemUIOverlayStyle(
    //     SystemUiOverlayStyle(statusBarColor: Color(0xff2c2c3c)));
    return LayoutBuilder(builder: (context, constraints) {
      final PageView pageView = PageView(
        // allowImplicitScrolling: true,
        children: [HomePage(), HomePage()],
      );
      return OrientationBuilder(
        builder: (context, orientation) {
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
            home: pageView,
          ),
        );
      });
    });
  }
}
