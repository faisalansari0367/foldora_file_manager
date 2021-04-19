import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';

import 'Utils.dart';

class SearchUtils {
  static bool _checkIfFound(String path, String query) {
    return p.basename(path).toLowerCase().contains(query.toLowerCase());
  }

  static bool searchWithExtension(String path, String query) {
    return p.extension(path).toLowerCase() == query.toLowerCase();
  }

  static const _excludedPath = '/storage/emulated/0/Android';

  static Future<void> addSuggestions(
      SharedPreferences prefs, String query) async {
    var suggestions = prefs.getStringList('suggestions') ?? [];
    if (suggestions.contains(query)) {
      int index = suggestions.indexOf(query);
      suggestions.removeAt(index);
      suggestions.insert(0, query);
      await prefs.setStringList('suggestions', suggestions);
    } else {
      if (query.isNotEmpty) suggestions.insert(0, query);
      await prefs.setStringList('suggestions', suggestions);
    }
  }

  static Stream searchDelegate(
      {String path, String query, bool withExt = false}) async* {
    List<FileSystemEntity> results = [];
    final Directory dir = Directory(path);

    Stream<FileSystemEntity> stream = dir.list();

    try {
      await for (var i in stream) {
        if (!i.path.contains(_excludedPath)) {
          if (i is Directory) {
            final stream = i.list(recursive: true);
            await for (var item in stream) {
              if (withExt) {
                if (searchWithExtension(item.path, query)) results.add(item);
              } else {
                if (_checkIfFound(item.path, query)) results.add(item);
              }
            }
          }
        }
        if (_checkIfFound(i.path, query)) results.add(i);
      }
    } catch (e) {
      print('error from searchDelegate: $e');
      Exception(e);
    }
    FileUtils.sortListAlphabetically(results);
    yield results;
  }

  static Future<List> doSearching(Map<String, dynamic> args) async {
    // args
    final String path = args['path'];
    final String query = args['query'];
    final bool withExt = args['withExt'];
    final bool wantOnlyPath = args['wantOnlyPath'];
    //
    final Stream<FileSystemEntity> stream = Directory(path).list();
    List<FileSystemEntity> results = [];
    List<String> paths = [];
    try {
      await for (var i in stream) {
        if (!i.path.contains(_excludedPath)) {
          if (i is Directory) {
            final stream = i.list(recursive: true);
            await for (var item in stream) {
              if (withExt) {
                if (wantOnlyPath) {
                  if (searchWithExtension(item.path, query))
                    paths.add(item.path);
                } else {
                  if (searchWithExtension(item.path, query)) results.add(item);
                }
              } else {
                if (_checkIfFound(item.path, query)) results.add(item);
              }
            }
          }
        }
        if (_checkIfFound(i.path, query)) results.add(i);
      }
    } catch (e) {
      print('error from searchDelegate: $e');
      Exception(e);
    }
    return wantOnlyPath ? paths : results;
  }
}
