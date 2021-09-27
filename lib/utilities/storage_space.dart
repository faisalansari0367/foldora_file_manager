import 'package:flutter/services.dart';

class StorageSpace {
  static const MethodChannel _channel = MethodChannel('com.faisal.foldora');
  static Future<bool> deleteWhenError(List<String> paths) async {
    try {
      final result = await _channel.invokeMethod(
        'deleteWhenError',
        <String, List<String>>{'paths': paths},
      );
      return result;
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<void> getAllFilesAccessPermission() async {
    try {
      await _channel.invokeMethod('manageAllFilesPermission');
    } catch (e) {
      rethrow;
    }
  }
}
