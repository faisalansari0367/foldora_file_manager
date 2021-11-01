import 'package:files/constants/assets/onboard.dart';
import 'package:files/pages/splash/screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DriveScreen extends StatefulWidget {
  const DriveScreen({Key key, User user}) : super(key: key);

  @override
  _DriveScreenState createState() => _DriveScreenState();
}

class _DriveScreenState extends State<DriveScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Screen(
        path: Onboard.folderFiles,
        title: Screen.titleWidget('Welcome to', 'Drive'),
        buttonText: 'Let\'s Go',
      ),
    );
  }
}
