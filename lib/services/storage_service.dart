import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

// abstract class _LocalStorage {}

class PrefsKeys {
  static const String firstSeen = 'firstSeen';
}

class StorageService {
  static SharedPreferences prefs;
  static final _completer = Completer<void>();
  Future<void> get isReady async => await _completer.future;

  // initialising the SharedPreferences only once
  StorageService() {
    _init();
  }

  Future<void> _init() async {
    print('initialising storage service...');
    if (prefs != null) return;
    final _prefs = await SharedPreferences.getInstance();
    prefs = _prefs;
    if (!_completer.isCompleted) _completer.complete();
    print('storage service initialised');
  }

  bool setFirstTimeSeen() {
    final isSeen = prefs.getBool(PrefsKeys.firstSeen) ?? false;
    return isSeen;
  }
}
