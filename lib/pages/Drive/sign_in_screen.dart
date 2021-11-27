import 'package:files/constants/assets/onboard.dart';
import 'package:files/pages/splash/screen.dart';
// import 'package:files/services/auth/auth.dart';
import 'package:files/services/gdrive/auth.dart';
import 'package:files/utilities/MyColors.dart';
import 'package:flutter/material.dart';

// import 'widget.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
      await Auth.initializeFirebase(context: context);
      

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.white,
      body: SafeArea(
        child: Screen(
          onPressed: () => Auth.initializeFirebase(context: context),
          path: Onboard.ourSolution,
          buttonText: 'Sign in with Google',
          title: Screen.titleWidget('Login to', 'Google Drive'),
        ),
      ),
    );
  }
}
