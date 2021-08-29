import 'package:files/pages/HomePage/HomePage.dart';
import 'package:files/provider/LeadingIconProvider.dart';
import 'package:files/provider/OperationsProvider.dart';
import 'package:files/provider/StoragePathProvider.dart';
import 'package:files/provider/MyProvider.dart';
import 'package:files/provider/scroll_provider.dart';
import 'package:files/sizeConfig.dart';
import 'package:files/utilities/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'sizeConfig.dart';
import 'widgets/splash_screen.dart';

void main() {
  runApp(MyApp());
}

// This widget is the root of your application.

void systemOverlay() {
  SystemChrome.setEnabledSystemUIMode(
      // overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
      SystemUiMode.immersive);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<bool> setFirstTimeSeen() async {
    final prefs = await SharedPreferences.getInstance();
    final isSeen = prefs.getBool('firstSeen') ?? false;
    return isSeen;
  }

  final PageView pageView = PageView(
    children: [HomePage(), HomePage()],
  );

  @override
  Widget build(BuildContext context) {
    final futureBuilder = FutureBuilder(
      future: setFirstTimeSeen(),
      initialData: false,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return snapshot.data ? pageView : SplashScreen();
      },
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            Responsive().init(constraints, orientation);
            return MultiProvider(
              providers: [
                ChangeNotifierProvider<MyProvider>(
                  create: (context) => MyProvider(),
                ),
                ChangeNotifierProvider<StoragePathProvider>(
                  create: (context) => StoragePathProvider(),
                ),
                ChangeNotifierProvider<IconProvider>(
                  create: (context) => IconProvider(),
                ),
                ChangeNotifierProvider<OperationsProvider>(
                  create: (context) => OperationsProvider(),
                ),
                ChangeNotifierProvider<ScrollProvider>(
                  create: (context) => ScrollProvider(),
                ),
              ],
              child: MaterialApp(
                theme: MyColors.themeData,
                showPerformanceOverlay: false,
                debugShowCheckedModeBanner: false,
                title: 'Foldora',
                home: futureBuilder,
              ),
            );
          },
        );
      },
    );
  }
}
