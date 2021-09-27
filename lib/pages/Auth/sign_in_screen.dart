import 'package:files/pages/Battery/battery.dart';
import 'package:files/services/auth/auth.dart';
import 'package:files/utilities/MediaListItemUtils.dart';
import 'package:files/utilities/MyColors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../sizeConfig.dart';
// import 'widget.dart';

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
    // return Home();
    return BatteryScreen();
    // return Scaffold(
    //   body: FutureBuilder<List<File>>(
    //     future: Auth.driveApi(),
    //     initialData: [],
    //     builder: (BuildContext context, AsyncSnapshot snapshot) {
    //       if (!snapshot.hasData) return CircularProgressIndicator();
    //       final List<File> data = snapshot.data;
    //       return ListView.builder(
    //         itemCount: data.length,
    //         itemBuilder: (BuildContext context, int index) {
    //           final file = data[index];
    //           return ListTile(
    //             title: Text(file.name),
    //             subtitle: Text(file.size),
    //           );
    //         },
    //       );
    //     },
    //   ),
    // );
  }
}

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: CustomColors.firebaseNavy,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: 20.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    Text(
                      'FlutterFire',
                      style: TextStyle(
                        fontSize: 40,
                      ),
                    ),
                    Text(
                      'Authentication',
                      style: TextStyle(
                        fontSize: 40,
                      ),
                    ),
                  ],
                ),
              ),
              FutureBuilder(
                future: Auth.initializeFirebase(context: context),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error initializing Firebase');
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    return ElevatedButton(
                      onPressed: () async {
                        final user = await Auth.signInWithGoogle(context: context);
                        if (user != null) MediaUtils.redirectToPage(context, page: DriveScreen());
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 4,
                        primary: MyColors.teal,
                        shadowColor: MyColors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0),
                          side: BorderSide(color: MyColors.teal),
                        ),
                        minimumSize: Size(Responsive.width(87), Responsive.height(6)),
                      ),
                      child: Text('Sign in with Google'),
                    );
                  }
                  return CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      MyColors.teal,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
