import 'package:files/pages/HomePage/HomePage.dart';
import 'package:files/provider/LeadingIconProvider.dart';
import 'package:files/provider/OperationsProvider.dart';
import 'package:files/provider/StoragePathProvider.dart';
import 'package:files/provider/MyProvider.dart';
import 'package:files/provider/scroll_provider.dart';
import 'package:files/services/storage_service.dart';
import 'package:files/sizeConfig.dart';
import 'package:files/utilities/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'sizeConfig.dart';
import 'utilities/Utils.dart';
import 'widgets/MyAppBar.dart';
import 'pages/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FileUtils();
  SystemChrome.setSystemUIOverlayStyle(AppbarUtils.systemUiOverylay());
  StorageService();
  await StorageService().isReady;
  runApp(MyApp());
}

// This widget is the root of your application.

// void systemOverlay() {
//   SystemChrome.setEnabledSystemUIMode(
//       // overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
//       SystemUiMode.immersive);
//   SystemChrome.setPreferredOrientations([
//     DeviceOrientation.portraitUp,
//     DeviceOrientation.portraitDown,
//   ]);
// }

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget child;

  final PageView pageView = PageView(
    children: [HomePage(), HomePage()],
  );

  @override
  void initState() {
    super.initState();
    child = StorageService().getFirstTimeSeen ? pageView : SplashScreen();
  }

  @override
  Widget build(BuildContext context) {
    // var widget = pageView;
    // setFirstTimeSeen() ?
    //  FutureBuilder(
    //   future: setFirstTimeSeen(),
    //   initialData: false,
    //   builder: (BuildContext context, AsyncSnapshot snapshot) {
    //     return snapshot.data ? pageView : SplashScreen();
    //   },
    // );

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
                // showPerformanceOverlay: true,
                debugShowCheckedModeBanner: false,
                title: 'Foldora',
                home: child,
              ),
            );
          },
        );
      },
    );
  }
}

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({Key key}) : super(key: key);

//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.white,
//       child: Center(
//         child: Image.asset(
//           // 'assets/icon/app_icon.png'
//           'icon/app_icon.png',
//         ),
//       ),
//     );
//   }
// }
