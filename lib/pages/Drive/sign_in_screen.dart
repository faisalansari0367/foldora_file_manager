import 'package:files/constants/assets/onboard.dart';
import 'package:files/helpers/provider_helpers.dart';
import 'package:files/pages/Drive/drive_screen.dart';
import 'package:files/pages/splash/screen.dart';
import 'package:files/provider/drive_provider/drive_provider.dart';
// import 'package:files/services/auth/auth.dart';
import 'package:files/services/gdrive/auth.dart';
import 'package:files/utilities/MyColors.dart';
import 'package:flutter/material.dart';

// import 'widget.dart';

class DriveSignInScreen extends StatefulWidget {
  const DriveSignInScreen({Key key}) : super(key: key);

  @override
  _DriveSignInScreenState createState() => _DriveSignInScreenState();
}

class _DriveSignInScreenState extends State<DriveSignInScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onPressed();
    });
  }

  void onPressed() async {
    // ignore: unawaited_futures
    Auth.initializeFirebase();
    // ignore: unawaited_futures
    if (mounted) getProvider<DriveProvider>(context).init();
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => DriveScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.white,
      body: SafeArea(
        child: Screen(
          // onPressed: onPressed,
          path: Onboard.ourSolution,
          buttonText: 'Signing in please wait...',
          title: Screen.titleWidget('Logging in to', 'Google Drive'),
          showLoader: true,
        ),
      ),
    );
  }
}
