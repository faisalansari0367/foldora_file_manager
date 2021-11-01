import 'dart:async';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

// abstract class _LocalStorage {}

class HiveKeys {
  static const String firstSeen = 'firstSeen';
  static const String showHidden = 'showHidden';
  static const String isDarkMode = 'isDarkMode';
  static const String suggestions = 'suggestions';
}

class StorageService {
  // static SharedPreferences prefs;
  static final _completer = Completer<void>();
  Future<void> get isReady async => await _completer.future;
  static Box box;
  // ignore: prefer_final_fields
  static bool _isInstantiated = false;

  Box<E> getKey<E>(String key) => Hive.box(key);

  StorageService() {
    if (!_isInstantiated) {
      _isInstantiated = true;
      _init();
    }
  }

  Future<void> _init() async {
    print('initialising storage service...');
    await Hive.initFlutter();
    box = await Hive.openBox('storage');
    if (!_completer.isCompleted) _completer.complete();
    print('storage service initialised');
  }

  Future<void> setFirstTimeSeen() async => await box.put(HiveKeys.firstSeen, true);

  List<String> get getSearchSuggestions {
    final suggestion = box.get(HiveKeys.suggestions, defaultValue: <String>[]);
    return suggestion;
  }

   Future<void> setSearchSuggestions(List<String> suggestions) async => await box.put(HiveKeys.suggestions, suggestions);

  bool get getFirstTimeSeen {
    final isSeen = box.get(HiveKeys.firstSeen, defaultValue: false);
    return isSeen;
  }
}
