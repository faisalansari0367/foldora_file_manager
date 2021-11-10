import 'package:files/pages/Drive/drive_screen.dart';
import 'package:files/services/gdrive/base_drive.dart';
import 'package:files/utilities/MediaListItemUtils.dart';
import 'package:files/utilities/my_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' show DriveApi;

import 'drive_storage.dart';
import 'http_client.dart';

abstract class AuthImplementation {
  Future<void> signInWithGoogle({@required context});
  Future<void> signOut({@required BuildContext context});
}

class Auth {
  static Future<void> initializeFirebase({@required BuildContext context}) async {
    final user = FirebaseAuth.instance.currentUser;
    FirebaseAuth.instance.authStateChanges().listen((event) async {
      if (user != null) {
        final client = DriveStorage().getClient();
        MyDrive(client);
        await Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DriveScreen(user: user),
          ),
        );
      } else {
        await signInWithGoogle(context: context);
      }
    });
  }

  static Future<GoogleHttpClient> getClient(GoogleSignInAccount googleSignInAccount) async {
    final drive = DriveStorage();
    final headers = await googleSignInAccount.authHeaders;
    await drive.saveClient(headers);
    return GoogleHttpClient(headers);
  }

  static Future<GoogleSignInAccount> driveSignIn() async {
    try {
      final googleSignIn = GoogleSignIn(scopes: [DriveApi.driveScope]);
      final googleSignInAccount = await googleSignIn.signIn();
      return googleSignInAccount;
    } catch (e) {
      rethrow;
    }
  }

  static Future<User> signInWithGoogle({BuildContext context}) async {
    User user;
    final auth = FirebaseAuth.instance;
    try {
      final googleSignInAccount = await driveSignIn();
      assert(googleSignInAccount != null);
      await getClient(googleSignInAccount);
      final authentication = await googleSignInAccount.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: authentication.accessToken,
        idToken: authentication.idToken,
      );
      final userCredential = await auth.signInWithCredential(credential);
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      MySnackBar.show(context, content: e.toString());
      rethrow;
    } catch (e) {
      rethrow;
    }

    return user;
  }

  static Future<void> signOut({@required BuildContext context}) async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      MySnackBar.show(
        context,
        content: 'Error signing out. Try again.',
      );
    }
  }
}
