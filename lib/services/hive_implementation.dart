import 'dart:async';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class HiveImplementation {
  final _completer = Completer<void>();
  Future<void> get isReady async => await _completer.future;
  Future<Box> init(String boxName) async {
    print('initialising box $boxName');
    final box = await Hive.openBox(boxName);
    if (!_completer.isCompleted) _completer.complete();
    print('storage box $boxName initialised');
    return box;
  }
}
