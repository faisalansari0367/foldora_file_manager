import 'dart:developer';

import 'package:files/services/gdrive/base_drive.dart';
import 'package:files/utilities/my_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' show DriveApi;

import 'drive_storage.dart';
import 'http_client.dart';

abstract class AuthImplementation {
  Future<void> signInWithGoogle({required context});
  Future<void> signOut({required BuildContext context});
}

class Auth {
  static final googleSignIn = GoogleSignIn(scopes: [DriveApi.driveScope]);
  static User? user;

  static User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  static Future<void> initializeFirebase() async {
    try {
      var isSignedIn = await googleSignIn.isSignedIn();
      if (isSignedIn) {
        await initDrive();
      } else {
        await signInWithGoogle(googleSignIn);
      }
    } catch (e) {
      log(e.toString());
      // MySnackBar.show(content: e.code);
    }
  }

  static Future<void> initDrive() async {
    GoogleSignInAccount? gsa;
    gsa = await googleSignIn.signInSilently();
    gsa ??= await googleSignIn.signIn();
    log('sign in silently result: $gsa');
    final client = await getClient(gsa!);
    // await signInWithGoogle(googleSignIn);
    MyDrive(client);
  }

  static Future<GoogleHttpClient> getClient(GoogleSignInAccount googleSignInAccount) async {
    final drive = DriveStorage();
    final headers = await googleSignInAccount.authHeaders;
    log('headers: $headers');
    await drive.saveClient(headers);
    return GoogleHttpClient(headers);
  }

  static Future<GoogleSignInAccount?> driveSignIn(GoogleSignIn googleSignIn) async {
    final googleSignInAccount = await googleSignIn.signIn();
    return googleSignInAccount;
  }

  static Future<User?> signInWithGoogle(googleSignin, {BuildContext? context}) async {
    final auth = FirebaseAuth.instance;
    try {
      final googleSignInAccount = (await driveSignIn(googleSignin))!;
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
      log(e.toString());

      if (context != null) MySnackBar.show(content: e.toString());
      rethrow;
    } catch (e) {
      log(e.toString());
      rethrow;
    }

    return user;
  }

  static Future<void> signOut({required BuildContext context}) async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      MySnackBar.show(
        content: 'Error signing out. Try again.',
      );
    }
  }
}
