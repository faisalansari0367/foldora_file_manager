import 'package:files/pages/Drive/drive_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' show DriveApi, File;

import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';

// import 'package:http/io_client.dart';
// import 'package:http/http.dart' as http;

// class GoogleHttpClient extends Client {
//  final Map<String, String> _headers;
//  GoogleHttpClient(this._headers) : super();
//  @override
//  Future<http.> send(http.BaseRequest request) async {
//    return super.send(request..headers.addAll(_headers));
//  }
//  @override
//  Future<http.Response> head(Object url, {Map<String, String> headers}) =>
//      super.head(url, headers: headers..addAll(_headers));
// }

class Auth {
  static Future<void> signInToDrive() async {
    try {
      var firebase = await Firebase.initializeApp();
      
      print(firebase.toString());

      final googleSignIn = GoogleSignIn.standard(scopes: [DriveApi.driveScope]);
      
      final account = await googleSignIn.signIn();
      customSnackBar(content: account.toString());
      print('User account $account');
    } catch (e) {
      print(e);
    }
  }

  static SnackBar customSnackBar({@required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }

  static Future<FirebaseApp> initializeFirebase({@required BuildContext context}) async {
    final firebaseApp = await Firebase.initializeApp();

    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => DriveScreen(
            user: user,
          ),
        ),
      );
    }
    //  else {
    //   await signInWithGoogle(context: context);
    // }

    return firebaseApp;
  }

  static Future<List<File>> driveApi() async {
    try {
      // await GoogleSignIn(clientId: 'AIzaSyAHxoNkBcPRcw3XKQOnTSBzEAaqQctWaRA');

      final googleSignIn = GoogleSignIn.standard(scopes: [DriveApi.driveScope]);
      final result = await googleSignIn.signIn();
      print(result);
      final client = await googleSignIn.authenticatedClient();
      final drive = DriveApi(client);
      final files = await drive.files.list();
      return files.files;
    } catch (e) {
      print(' errorororororo: $e');
      rethrow;
    }
  }

  static Future<User> signInWithGoogle({BuildContext context}) async {
    final auth = FirebaseAuth.instance;
    User user;

    final googleSignIn = GoogleSignIn();

    final googleSignInAccount = await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final googleSignInAuthentication = await googleSignInAccount.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final userCredential = await auth.signInWithCredential(credential);

        user = userCredential.user;
        await Fluttertoast.showToast(msg: user.toString());
      } on FirebaseAuthException catch (e) {
        await Fluttertoast.showToast(msg: e.toString());
        if (e.code == 'account-exists-with-different-credential') {
          // handle the error here

        } else if (e.code == 'invalid-credential') {
          // handle the error here
        }
      } catch (e) {
        // handle the error here
      }
    }

    return user;
  }

  static Future<void> signOut({@required BuildContext context}) async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        Auth.customSnackBar(
          content: 'Error signing out. Try again.',
        ),
      );
    }
  }
}
