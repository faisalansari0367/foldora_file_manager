import 'dart:io';

import 'package:files/services/storage_service.dart';
import 'package:path/path.dart' as p;

import 'Utils.dart';

class SearchUtils {
  static bool _checkIfFound(String path, String query) {
    return p.basename(path).toLowerCase().contains(query.toLowerCase());
  }

  static bool searchWithExtension(String path, String query) {
    return p.extension(path).toLowerCase() == query.toLowerCase();
  }

  static const _excludedPath = '/storage/emulated/0/Android';

  static Future<void> addSuggestions(String query) async {
    final storage = StorageService();
    final suggestions = storage.getSearchSuggestions;
    if (suggestions.contains(query)) {
      final index = suggestions.indexOf(query);
      suggestions.removeAt(index);
      suggestions.insert(0, query);
      await storage.setSearchSuggestions(suggestions);
    } else {
      if (query.isNotEmpty) suggestions.insert(0, query);
      await storage.setSearchSuggestions(suggestions);
    }
  }

  static Stream searchDelegate({String path, String query, bool withExt = false}) async* {
    final results = <FileSystemEntity>[];
    final dir = Directory(path);

    final stream = dir.list();

    try {
      await for (final i in stream) {
        if (!i.path.contains(_excludedPath)) {
          if (i is Directory) {
            final stream = i.list(recursive: true);
            await for (final item in stream) {
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
    final stream = Directory(path).list();
    final results = <FileSystemEntity>[];
    final paths = <String>[];
    try {
      await for (final i in stream) {
        if (!i.path.contains(_excludedPath)) {
          if (i is Directory) {
            final stream = i.list(recursive: true);
            await for (final item in stream) {
              if (withExt) {
                if (wantOnlyPath) {
                  if (searchWithExtension(item.path, query)) {
                    paths.add(item.path);
                  }
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
