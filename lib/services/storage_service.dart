import 'dart:async';

import 'package:files/services/hive_implementation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class StorageKeys {
  static const String boxName = 'storage';
  static const String firstSeen = 'firstSeen';
  static const String showHidden = 'showHidden';
  static const String isDarkMode = 'isDarkMode';
  static const String suggestions = 'suggestions';
}

class StorageService extends HiveImplementation {
  static Box box;
  static var _init = false;

  StorageService() {
    if (_init) return;
    _init = true;
    initService();
  }

  void initService() async {
    final box = await init(StorageKeys.boxName);
    StorageService.box = box;
    await isReady;
  }

  Future<void> setFirstTimeSeen() async => await box.put(StorageKeys.firstSeen, true);

  List<String> get getSearchSuggestions {
    final suggestion = box.get(StorageKeys.suggestions, defaultValue: <String>[]);
    return suggestion;
  }

  Future<void> setSearchSuggestions(List<String> suggestions) async =>
      await box.put(StorageKeys.suggestions, suggestions);

  bool get getFirstTimeSeen {
    final isSeen = box.get(StorageKeys.firstSeen, defaultValue: false);
    return isSeen;
  }
}
