import 'dart:developer';

import 'package:files/SizeConfigWidget.dart';
import 'package:files/multi_providers.dart';
import 'package:files/pages/HomePage/HomePage.dart';
import 'package:files/services/gdrive/drive_storage.dart';
import 'package:files/services/storage_service.dart';
import 'package:files/utilities/MyColors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'utilities/Utils.dart';
import 'widgets/MyAppBar.dart';
import 'pages/splash/splash_screen.dart';

Future<void> init() async {
  await Future.wait([
    Firebase.initializeApp(),
    StorageService().isReady,
    DriveStorage().isReady,
  ]);
}

void main() async {
  final stopwatch = Stopwatch()..start();
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await init();
  FileUtils();
  // await Auth.initializeFirebase();
  // SystemChrome.setSystemUIOverlayStyle(AppbarUtils.systemUiOverylay());
  log('App initialised in ' + stopwatch.elapsedMilliseconds.toString());
  runApp(MyApp());
}

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
    return AddProviders(
      child: SizeConfig(
        child: MaterialApp(
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
