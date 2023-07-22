import 'dart:typed_data';

// import 'package:device_apps/app_utils.dart';

class Apps {
  final String? filePath;
  final Uint8List? icon;
  final String? name;
  final String? packageName;

  Apps({
    this.filePath,
    this.icon,
    this.name,
    this.packageName,
  });

  static Map<String, dynamic> toMap(app) {
    return {
      'app_name': app.appName,
      'package_name': app.packageName,
      'apk_file_path': app.apkFilePath,
      'app_icon': app.appIcon,
    };
  }

  static List<Apps> fromMap(List list) {
    return List.generate(list.length, (i) {
      final map = list[i];
      return Apps(
        filePath: map['apk_file_path'],
        icon: map['app_icon'],
        name: map['app_name'],
        packageName: map['package_name'],
      );
    });
  }
}
