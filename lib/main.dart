import 'dart:developer';

import 'package:files/SizeConfigWidget.dart';
import 'package:files/add_providers.dart';
import 'package:files/pages/HomePage/HomePage.dart';
import 'package:files/services/gdrive/drive_storage.dart';
import 'package:files/services/storage_service.dart';
import 'package:files/utilities/MyColors.dart';
import 'package:files/utilities/my_snackbar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'pages/splash/splash_screen.dart';
import 'utilities/Utils.dart';

Future<void> init() async {
  await Future.wait([
    StorageService().isReady,
    DriveStorage().isReady,
  ]);

  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
  //   systemNavigationBarColor: Colors.white, // navigation bar color
  // statusBarColor: Colors.pink, // status bar color
  // statusBarBrightness: Brightness.dark, //status bar brigtness
  // statusBarIconBrightness: Brightness.dark, //status barIcon Brightness
  // systemNavigationBarDividerColor: Colors.greenAccent, //Navigation bar divider color
  // systemNavigationBarIconBrightness: Brightness.light, //navigation bar icon
  // ));
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  final stopwatch = Stopwatch()..start();
  await Hive.initFlutter();
  await init();
  FileUtils();
  log('App initialised in ' + stopwatch.elapsedMilliseconds.toString());
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget? child;

  final PageView pageView = PageView(
    children: [HomePage(), HomePage()],
  );

  @override
  void initState() {
    super.initState();
    child = StorageService().getFirstTimeSeen! ? pageView : SplashScreen();
  }

  @override
  Widget build(BuildContext context) {
    return AddProviders(
      child: SizeConfig(
        child: MaterialApp(
          scaffoldMessengerKey: MySnackBar.myMessengerKey,
          theme: MyColors.themeData,
          // showPerformanceOverlay: true,
          debugShowCheckedModeBanner: false,
          title: 'Foldora',
          home: child,
        ),
      ),
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
