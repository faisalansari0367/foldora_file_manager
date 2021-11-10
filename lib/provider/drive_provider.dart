import 'dart:async';

import 'package:files/services/gdrive/auth.dart';
import 'package:files/services/gdrive/base_drive.dart';
import 'package:files/utilities/my_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:googleapis/drive/v3.dart';

class DriveProvider extends ChangeNotifier {
  final _completer = Completer<void>();
  Future<void> get isReady async => await _completer.future;
  AboutStorageQuota driveQuota;
  bool isLoading = false;
  BuildContext context;

  DriveProvider() {
    _init();
  }

  void setContext(context) {
    this.context = context;
  }

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<void> renewClient() async {
    final googleSignInAccount = await Auth.driveSignIn();
    final client = await Auth.getClient(googleSignInAccount);
    MyDrive(client);
  }

  Future<void> _init() async {
    await getStorageQuota();
    _completer.complete();
  }

  Future<List<File>> getDriveFiles() async {
    await isReady;
    try {
      final data = await MyDrive.driveFiles();
      return data;
    } catch (e) {
      MySnackBar.show(context, content: e.message);
      return [];
    }
  }

  Future<void> getStorageQuota() async {
    setLoading(true);
    try {
      final about = await MyDrive.getDriveStorageQuota();
      driveQuota = about.storageQuota;
      notifyListeners();
    } on DetailedApiRequestError catch (e) {
      MySnackBar.show(context, content: e.message);
      await renewClient();
      await getStorageQuota();
    }
  }
}
