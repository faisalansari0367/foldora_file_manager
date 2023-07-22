import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuth extends ChangeNotifier {
  late LocalAuthentication _localAuth;
  List<BiometricType> availableBiometrics = [];
  bool isSupported = false;
  final _isInstantiated = Completer<void>();
  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;


  LocalAuth() {
    _init();
  }

  void _init() async {
    _localAuth = LocalAuthentication();
    final canCheck = await _localAuth.canCheckBiometrics;
    log('can check authentication: $canCheck');
    availableBiometrics = await _localAuth.getAvailableBiometrics();
    print(availableBiometrics);
    isSupported = await _localAuth.isDeviceSupported();
    _isInstantiated.complete();
    print('isSupported $isSupported');
  }

  Future<bool> authenticate() async {
    await _isInstantiated.future;
    final result = await _localAuth.authenticate(
      localizedReason: 'Please authenticate to open drive',
    );
    _isAuthenticated = result;
    notifyListeners();
    return result;
  }
}
