import 'package:flutter/services.dart';

class StorageSpace {
  static const MethodChannel _channel = const MethodChannel('com.example.files');
  static Future<bool> deleteWhenError(List<String> paths) async {
    try {
      var result = await _channel.invokeMethod(
        'deleteWhenError',
        <String, List<String>>{'paths': paths},
      );
      return result;
    } catch (e) {
      throw Exception(e);
    }
  }
}